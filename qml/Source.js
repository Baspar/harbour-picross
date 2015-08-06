function initVoid(){
    game.mySolvingGrid.clear()
    game.nbSolvingFullCell=0
    for(var i=0; i<game.dimension*game.dimension; i++)
        game.mySolvingGrid.append({"myEstate":"void"})

    for(i=0; i<game.dimension; i++){
        checkLineX(i)
        checkColX(i)
    }
}
function loadSave(save){
    game.mySolvingGrid.clear()
    game.nbSolvingFullCell=0
    for(var i=0; i<save.length; i++){
        game.mySolvingGrid.append({"myEstate":save[i]==="0"?"void":save[i]==="1"?"full":"hint"})
        if(save[i]==="1")
            game.nbSolvingFullCell++
    }
    for(i=0; i<game.dimension; i++){
        checkLineX(i)
        checkColX(i)
    }
}

function click(grid, x){
    var str=grid.get(x).myEstate
    if(str==="full")
        game.nbSolvingFullCell--
    else
        game.nbSolvingFullCell++

    grid.set(x, {"myEstate":str==="full"?"hint":"full"})

    checkLineX(Math.floor(x/game.dimension))
    checkColX(x%game.dimension)

    launchCheckWin()
}
function longClick(grid, x){
    var str=grid.get(x).myEstate
    if(str==="full")
        game.nbSolvingFullCell--

    grid.set(x, {"myEstate":"void"})

    checkLineX(Math.floor(x/game.dimension))
    checkColX(x%game.dimension)

    launchCheckWin()
}
function doubleClick(grid, x){
    var str=grid.get(x).myEstate
    if(str==="full")
        game.nbSolvingFullCell--
    grid.set(x, {"myEstate":"hint"})
    if(game.nbSolvedFullCell===game.nbSolvingFullCell)
        game.checkWin()

    checkLineX(Math.floor(x/game.dimension))
    checkColX(x%game.dimension)
}

function genIndicLineXFilling(list, grid, x){
    list.clear()
    var cpt=0
    if(grid.count!==0){
        for(var coord=x*game.dimension; coord<(x+1)*game.dimension; coord++){
            if(grid.get(coord).myEstate !== "hint") {
                cpt++
            } else {
                if(cpt!=0)
                    list.append({"size":cpt})
                cpt=0
            }
        }
    }
    if(cpt!=0 || list.count===0)
        list.append({"size":cpt})
}
function genIndicColXFilling(list, grid, x){
    list.clear()
    var cpt=0
    if(grid.count!==0){
        for(var coord=x; coord<x+game.dimension*(game.dimension-1)+1; coord+=game.dimension){
            if(grid.get(coord).myEstate !== "hint") {
                cpt++
            } else {
                if(cpt!=0)
                    list.append({"size":cpt})
                cpt=0
            }
        }
    }
    if(cpt!=0 || list.count===0)
        list.append({"size":cpt})

}
function genIndicLineX(list, grid, x){
    list.clear()
    var cpt=0
    if(grid.count!==0){
        for(var coord=x*game.dimension; coord<(x+1)*game.dimension; coord++){
            if(grid.get(coord).myEstate === "full") {
                cpt++
            } else {
                if(cpt!=0)
                    list.append({"size":cpt})
                cpt=0
            }
        }
    }
    if(cpt!=0 || list.count===0)
        list.append({"size":cpt})
}
function genIndicColX(list, grid, x){
    list.clear()
    var cpt=0
    if(grid.count!==0){
        for(var coord=x; coord<x+game.dimension*(game.dimension-1)+1; coord+=game.dimension){
            if(grid.get(coord).myEstate === "full") {
                cpt++
            } else {
                if(cpt!=0)
                    list.append({"size":cpt})
                cpt=0
            }
        }
    }
    if(cpt!=0 || list.count===0)
        list.append({"size":cpt})

}
function genIndicLine(list, grid){
    list.clear()

    for(var i=0; i<game.dimension; i++){
        var smallList = Qt.createQmlObject('import QtQuick 2.2; \
                        ListModel {}', parent)

        smallList.clear()
        genIndicLineX(smallList, grid, i)
        list.append({"loadedIndic":smallList, "completed":false, "toFill":false})
    }
}
function genIndicCol(list, grid){
    list.clear()

    for(var i=0; i<game.dimension; i++){
        var smallList = Qt.createQmlObject('import QtQuick 2.2; \
                        ListModel {}', parent)

        smallList.clear()
        genIndicColX(smallList, grid, i)
        list.append({"loadedIndic":smallList, "completed":false, "toFill":false})
    }
}

function completeLineX(x, toFill){
    if(!toFill){
        for(var j=x*game.dimension; j<(x+1)*game.dimension; j++)
            if(game.mySolvingGrid.get(j).myEstate === "void")
                doubleClick(game.mySolvingGrid, j)
    }else{
        for(var k=x*game.dimension; k<(x+1)*game.dimension; k++)
            if(game.mySolvingGrid.get(k).myEstate === "void")
                click(game.mySolvingGrid, k)

    }
}
function completeColX(x, toFill){
    if(!toFill){
        for(var j=x; j<game.dimension*game.dimension; j+=game.dimension)
            if(game.mySolvingGrid.get(j).myEstate === "void")
                doubleClick(game.mySolvingGrid, j)
    }else{
        for(var k=x; k<game.dimension*game.dimension; k+=game.dimension)
            if(game.mySolvingGrid.get(k).myEstate === "void")
                click(game.mySolvingGrid, k)

    }

}

function checkColX(x){
    var indics=game.indicUp.get(x).loadedIndic
    var progress = Qt.createQmlObject('import QtQuick 2.2; \
                    ListModel {}', parent)
    genIndicColX(progress, game.mySolvingGrid, x)

    //Variables
    var completed=(progress.count===indics.count)
    var toFill=false

    //Check if we can fill with crosses (i.e. ours indicators correspond)
    for(var i=0; i<progress.count; i++)
        completed=completed&&(progress.get(i).size===indics.get(i).size)

    //If not, check if we can fill with full
    if(!completed){
        genIndicColXFilling(progress, game.mySolvingGrid, x)
        toFill=(progress.count===indics.count)
        for(var i=0; i<progress.count; i++)
            toFill=toFill&&(progress.get(i).size===indics.get(i).size)
    }

    game.indicUp.setProperty(x, "completed", completed)
    game.indicUp.setProperty(x, "toFill", toFill)
}
function checkLineX(x){
    var indics=game.indicLeft.get(x).loadedIndic
    var progress = Qt.createQmlObject('import QtQuick 2.2; \
                    ListModel {}', parent)
    genIndicLineX(progress, game.mySolvingGrid, x)

    //Variables
    var completed=(progress.count===indics.count)
    var toFill=false

    //Check if we can fill with crosses (i.e. ours indicators correspond)
    for(var i=0; i<progress.count; i++)
        completed=completed&&(progress.get(i).size===indics.get(i).size)

    //If not, check if we can fill with full
    if(!completed){
        genIndicLineXFilling(progress, game.mySolvingGrid, x)
        toFill=(progress.count===indics.count)
        for(var i=0; i<progress.count; i++)
            toFill=toFill&&(progress.get(i).size===indics.get(i).size)
    }

    game.indicLeft.setProperty(x, "completed", completed)
    game.indicLeft.setProperty(x, "toFill", toFill)
}

function launchCheckWin(){
    if(game.nbSolvedFullCell===game.nbSolvingFullCell)
        game.checkWin()
}
function checkWin(){
    var check=true
    for(var i=0; i<game.solvedGrid.count; i++){
        if(check){
            if(game.solvedGrid.get(i).myEstate==="full" && game.mySolvingGrid.get(i).myEstate!=="full")
                check=false

            if(game.solvedGrid.get(i).myEstate==="void" && game.mySolvingGrid.get(i).myEstate==="full")
                check=false
        }
    }
    return check
}
function clear(){
    for(var i=0; i<game.mySolvingGrid.count; i++)
        longClick(game.mySolvingGrid, i)
}
function nothingDone(){
    for(var i=0; i<game.mySolvingGrid.count; i++)
        if(game.mySolvingGrid.get(i).myEstate!=="void")
            return false
    return true
}
