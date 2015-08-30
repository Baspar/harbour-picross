.import "DB.js" as DB

function initVoid(){
    game.guessMode=false
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
    game.guessMode=false
    game.mySolvingGrid.clear()
    game.nbSolvingFullCell=0
    for(var i=0; i<save.length; i++){
        game.mySolvingGrid.append({"myEstate":save[i]==="0"?"void":save[i]==="1"?"full":save[i]==="2"?"hint":save[i]==="3"?"guess_full":"guess_hint"})
        if(save[i]==="1")
            game.nbSolvingFullCell++

        if(save[i]==="3" || save[i]==="4")
            if(!game.guessMode)
                game.guessMode=true
    }
    for(i=0; i<game.dimension; i++){
        checkLineX(i)
        checkColX(i)
    }
}


function save(){
    if(game.diff !== -1 && !checkWin() && !nothingDone())
        DB.save(game.mySolvingGrid, game.diff, game.level)
}
function click(grid, x){
    var str=grid.get(x).myEstate
    if(game.guessMode){
        if(str!=="full" && str!=="hint")
            grid.set(x, {"myEstate":str==="guess_full"?"guess_hint":str==="guess_hint"?"void":"guess_full"})
    } else {
        if(str==="full")
            game.nbSolvingFullCell--
        else if (str==="void")
            game.nbSolvingFullCell++

        grid.set(x, {"myEstate":str==="full"?"hint":str==="hint"?"void":"full"})
    }

    checkLineX(Math.floor(x/game.dimension))
    checkColX(x%game.dimension)

    launchCheckWin()
}
function longClick(grid, x){
    return
    if(game.selectedCol !== myID % game.dimension && game.selectedLine !== Math.floor(myID/game.dimension)){
        game.selectedCol = myID % game.dimension
        game.selectedLine = Math.floor(myID/game.dimension)
    } else {
        game.selectedCol = -1
        game.selectedLine = -1
    }
}
function doubleClick(grid, x){
    if(!game.guessMode)
        grid.set(x, {"myEstate":"hint"})
    else
        grid.set(x, {"myEstate":"guess_hint"})

    checkLineX(Math.floor(x/game.dimension))
    checkColX(x%game.dimension)
}

function genIndicLineXFilling(list, grid, x){
    list.clear()
    var cpt=0
    if(grid.count!==0){
        for(var coord=x*game.dimension; coord<(x+1)*game.dimension; coord++){
            if(grid.get(coord).myEstate !== "hint" && grid.get(coord).myEstate !== "guess_hint") {
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
            if(grid.get(coord).myEstate !== "hint" && grid.get(coord).myEstate !== "guess_hint") {
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
            if(grid.get(coord).myEstate === "full" || grid.get(coord).myEstate === "guess_full") {
                cpt++
            } else {
                if(cpt!=0)
                    list.append({"size":cpt, "isOk":'false'})
                cpt=0
            }
        }
    }
    if(cpt!=0 || list.count===0)
        list.append({"size":cpt, "isOk":'false'})
}
function genIndicColX(list, grid, x){
    list.clear()
    var cpt=0
    if(grid.count!==0){
        for(var coord=x; coord<x+game.dimension*(game.dimension-1)+1; coord+=game.dimension){
            if(grid.get(coord).myEstate === "full" || grid.get(coord).myEstate === "guess_full") {
                cpt++
            } else {
                if(cpt!=0)
                    list.append({"size":cpt, "isOk":'false'})
                cpt=0
            }
        }
    }
    if(cpt!=0 || list.count===0)
        list.append({"size":cpt, "isOk":'false'})

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

function checkErrorColX(x){
    var indics=game.indicUp.get(x).loadedIndic

    for(var j=0; j<indics.count ; j++)
        indics.setProperty(j, "isOk", false)

    var cpt=0
    var nbIndic=0
    var i=0
    var exit=false

    while(i<game.dimension && game.mySolvingGrid.get(x+game.dimension*i).myEstate !== "void" && !exit){
        var state=game.mySolvingGrid.get(x+game.dimension*i).myEstate
        if(state==="hint" || state==="guess_hint"){
            if(cpt!==0){
                if(cpt===indics.get(nbIndic).size){
                    indics.setProperty(nbIndic, "isOk", true)
                    nbIndic++
                } else {
                    exit=true
                }
                cpt=0
            }
        } else
            cpt++
        i++
    }

    var lim=game.dimension-i-cpt

    cpt=0
    nbIndic=indics.count-1
    i=game.dimension-1
    exit=false

    while(i>=lim && game.mySolvingGrid.get(x+game.dimension*i).myEstate !== "void" && !exit){
        state=game.mySolvingGrid.get(x+game.dimension*i).myEstate
        if(state==="hint" || state==="guess_hint"){
            if(cpt!==0){
                if(cpt===indics.get(nbIndic).size){
                    indics.setProperty(nbIndic, "isOk", true)
                    nbIndic--
                } else
                    exit=true
                cpt=0
            }
        } else
            cpt++
        i--
    }
}
function specialCheckColX(x){
    var indics=game.indicUp.get(x).loadedIndic

    for(var j=0; j<indics.count ; j++)
        indics.setProperty(j, "isOk", false)

    var cpt=0
    var nbIndic=0
    var i=0
    var exit=false

    while(i<game.dimension && game.mySolvingGrid.get(x+game.dimension*i).myEstate !== "void" && !exit){
        var state=game.mySolvingGrid.get(x+game.dimension*i).myEstate
        if(state==="hint" || state==="guess_hint"){
            if(cpt!==0){
                if(cpt===indics.get(nbIndic).size){
                    indics.setProperty(nbIndic, "isOk", true)
                    nbIndic++
                } else {
                    exit=true
                }
                cpt=0
            }
        } else
            cpt++
        i++
    }

    var lim=game.dimension-i-cpt

    cpt=0
    nbIndic=indics.count-1
    i=game.dimension-1
    exit=false

    while(i>=lim && game.mySolvingGrid.get(x+game.dimension*i).myEstate !== "void" && !exit){
        state=game.mySolvingGrid.get(x+game.dimension*i).myEstate
        if(state==="hint" || state==="guess_hint"){
            if(cpt!==0){
                if(cpt===indics.get(nbIndic).size){
                    indics.setProperty(nbIndic, "isOk", true)
                    nbIndic--
                } else
                    exit=true
                cpt=0
            }
        } else
            cpt++
        i--
    }
}
function specialCheckLineX(x){
    var indics=game.indicLeft.get(x).loadedIndic

    for(var j=0; j<indics.count ; j++)
        indics.setProperty(j, "isOk", false)

    var cpt=0
    var nbIndic=0
    var i=0
    var exit=false

    while(i<game.dimension && game.mySolvingGrid.get(x*game.dimension+i).myEstate !== "void" && !exit){
        var state=game.mySolvingGrid.get(x*game.dimension+i).myEstate
        if(state==="hint" || state==="guess_hint"){
            if(cpt!==0){
                if(cpt===indics.get(nbIndic).size){
                    indics.setProperty(nbIndic, "isOk", true)
                    nbIndic++
                } else {
                    exit=true
                }
                cpt=0
            }
        } else
            cpt++
        i++
    }


    var lim=game.dimension-i-cpt

    cpt=0
    nbIndic=indics.count-1
    i=game.dimension-1
    exit=false

    while(i>=lim && game.mySolvingGrid.get(x*game.dimension+i).myEstate !== "void" && !exit){
        state=game.mySolvingGrid.get(x*game.dimension+i).myEstate
        if(state==="hint" || state==="guess_hint"){
            if(cpt!==0){
                if(cpt===indics.get(nbIndic).size){
                    indics.setProperty(nbIndic, "isOk", true)
                    nbIndic--
                } else
                    exit=true
                cpt=0
            }
        } else
            cpt++
        i--
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
        for(i=0; i<progress.count; i++)
            toFill=toFill&&(progress.get(i).size===indics.get(i).size)
    }

    game.indicUp.setProperty(x, "completed", completed)
    game.indicUp.setProperty(x, "toFill", toFill)

    if(!completed){
        checkErrorColX(x)
        specialCheckColX(x)
    }
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

    if(!completed)
        specialCheckLineX(x)
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
        game.mySolvingGrid.set(i, {"myEstate":"void"})

    for(i=0; i<game.dimension; i++){
        checkLineX(i)
        checkColX(i)
    }
    game.nbSolvingFullCell=0
}
function nothingDone(){
    for(var i=0; i<game.mySolvingGrid.count; i++)
        if(game.mySolvingGrid.get(i).myEstate!=="void")
            return false
    return true
}
function noGuessDone(){
    for(var i=0; i<game.dimension*game.dimension; i++)
        if(game.mySolvingGrid.get(i).myEstate==="guess_full" || game.mySolvingGrid.get(i).myEstate==="guess_hint")
            return false
    return true
}

function rejectGuesses(){
    for(var i=0; i<game.dimension*game.dimension; i++){
        var state= game.mySolvingGrid.get(i).myEstate
        if(state==="guess_hint" || state==="guess_full")
            game.mySolvingGrid.setProperty(i, "myEstate", "void")
    }
    for(i=0; i<game.dimension; i++){
        checkLineX(i)
        checkColX(i)
    }
}
function acceptGuesses(){
    for(var i=0; i<game.dimension*game.dimension; i++){
        var state=game.mySolvingGrid.get(i).myEstate
        if(state==="guess_hint")
            game.mySolvingGrid.setProperty(i, "myEstate", "hint")
        if(state==="guess_full"){
            game.mySolvingGrid.setProperty(i, "myEstate", "full")
            game.nbSolvingFullCell++
        }
    }
    launchCheckWin()
}
