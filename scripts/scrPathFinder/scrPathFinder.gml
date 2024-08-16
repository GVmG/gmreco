
global.__recopaths=[pthA, pthB1, pthB2, pthC, pthD1, pthD2, pthE1, pthE2, pthF1, pthF2, pthG, pthH1, pthH2, pthI, pthJ, pthK, pthL, pthM, pthN1, pthN2, pthO, pthP, pthQ1, pthQ2, pthR1, pthR2, pthS1, pthS2, pthT, pthU, pthV, pthW, pthX1, pthX2, pthY, pthZ, pthStar, pthHunter];
global.__recoletters=["a", "b", "b", "c", "d", "d", "e", "e", "f", "f", "g", "h", "h", "i", "j", "k", "l", "m", "n", "n", "o", "p", "q", "q", "r", "r", "s", "s", "t", "u", "v", "w", "x", "x", "y", "z", "*", "#"];

///Compares a list of points with a path. Returns the average distance from each calculated point to the path's theoretical nearest progress point.
function comparePaths(listOfPoints, path, reverse=false, precision=16, normalizeKeepsRatio=false) {
	var dist=0;
	var mns=listOfPointsGetMinAndSize(listOfPoints); //obtain minimum coords and width/height of the list of points
	var std=0;
	
	for (var i=0; i<precision; i++) { //check multiple points
		var prog=i/precision; //progress along the path/list of points
		
		var pInList=listOfPoints[| floor(prog*ds_list_size(listOfPoints))]; //current point
		var px=(pInList[0]-mns.minX)/mns.w; //normalize the point's coords
		var py=(pInList[1]-mns.minY)/mns.h;
		
		if (normalizeKeepsRatio || (mns.w/mns.h<1/3 || mns.w/mns.h>3)) { //normalize while keeping the aspect ratio, if the ratio is otherwise too wacky or the arguments require so
			var norm=max(mns.w, mns.h);
			px=(pInList[0]-mns.minX)/norm;
			py=(pInList[1]-mns.minY)/norm;
		}
		
		var pInPathX=path_get_x(path, reverse ? 1-prog : prog)/64; //normalize path (they are in a 64x64 scale for simplicity)
		var pInPathY=path_get_y(path, reverse ? 1-prog : prog)/64;
		
		//choose between point_distance or squared distance. point_distance is the simple GameMaker solution that directly measures the distances and gives you the most accurate
		//precision rating of the listOfPoints. squared distance is essentially the same function as point_distance behind the scenes, minus a square root, which makes it ever so
		//slightly faster, though harder to read and up-scaling the precision rating a fair bit (not relevant to the algorithm but could affect code that uses it outside-script).
		dist+=(px-pInPathX)*(px-pInPathX)+(py-pInPathY)*(py-pInPathY); //squared distance
		//dist+=point_distance(px, py, pInPathX, pInPathY);
	}
	
	return dist/precision;
}

///Returns a struct containing info about the minimum x and y values of the input path, as well as width and height.
function listOfPointsGetMinAndSize(listOfPoints) {
	var ret={ minX:1999, minY:1999, w:0, h:0};
	
	for (var i=0; i<ds_list_size(listOfPoints); i++) { //check every point
		var p=listOfPoints[| i];
		
		if (p[0]<ret.minX) ret.minX=p[0]; //detect minimum coordinates
		if (p[1]<ret.minY) ret.minY=p[1];
		
		if (p[0]>ret.w) ret.w=p[0]; //detect right-most/bottom-most points
		if (p[1]>ret.h) ret.h=p[1];
	}
	
	ret.w-=ret.minX; //remove minimum coordinates from the right-most/bottom-most points, thus obtaining the width/height
	ret.h-=ret.minY;
	
	return ret;
}

///Checks the given list of points against all the paths in memory and returns the index of the closest fitting path.
///If "directionSensitive" is set to true, the path's direction is important to the check.
///If "normalizeKeepsRatio" is set to true, the aspect ratio of the listOfPoints will be kept instead of normalizing the two dimensions separately.
function checkAgainstPaths(listOfPoints, directionSensitive=false, precision=16, normalizeKeepsRatio=false) {
	var dist=9999, p=-1, pathCount=array_length(global.__recopaths);
	
	for (var i=0; i<(directionSensitive ? pathCount : pathCount*2); i++) { //make sure to check both ways if not direction-sensitive
		var ind=i % pathCount;
		var path=global.__recopaths[ind];
		var reverse=(i>=pathCount);
		
		var dd=comparePaths(listOfPoints, path, reverse, precision, normalizeKeepsRatio); //compare points to current path
		
		if (dd<dist) { //if it's a better match, store it
			dist=dd;
			p=ind;
		}
	}
	
	return [p, dist]; //return best match and the accuracy of the input
}

function pathIndexToLetter(path) {
	if (path<0 || path>=array_length(global.__recoletters)) return "?";
	else return global.__recoletters[path];
}
