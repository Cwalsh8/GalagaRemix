%Resetting MATLAB environment
    close all;
    clear all;
    clc;
%Main program
    fig = figure; %Lets us use fig to reference our current figure
    global x; %Sets x as a global variable
    global y;
    setGlobalx(5); %Sets the value of x using the function at the bottom
    setGlobaly(2);
    plot(x,y,'*'); %Plots x and y, using the star design.
    title('Galaga Remix');
    axis([0,10,0,10]);
    set(fig,'KeyPressFcn',@getKeys); %Sets the figure so on a keypress, the function @getKeys runs
    linkdata on %Linkdata is a slow solution to updating the graph, but usable for now as I make sure functions work. This checks every .5 seconds if the variable changed, and updates the figure if so.

 %List of functions
 
    function setGlobalx(val) %Function used to set global variable
        global x
        x = val;
    end
    
    function setGlobaly(val)
        global y
        y = val;
    end
    
    function xTemp = getGlobalx %Function used to get global variable
        global x
        xTemp = x;
    end
    
    function yTemp = getGlobaly
        global y
        yTemp = y;
    end
    
    function getKeys (fig,evt) %Returns the modifier and key pressed by user. Also moves the ship depending on what was pressed. May turn into seperate functions if turns too ugly.
        mod = evt.Modifier;
        keyPressed = evt.Key;
        disp(keyPressed);
        xTemp = getGlobalx;
        yTemp = getGlobaly;
        if (strcmpi(keyPressed, 'leftarrow'))
            xTemp = xTemp-1;
            setGlobalx(xTemp);
            disp(getGlobalx);
        end
        if (strcmpi(keyPressed, 'rightarrow'))
            xTemp = xTemp+1;
            setGlobalx(xTemp);
            disp(getGlobalx);
        end
        if (strcmpi(keyPressed, 'uparrow'))
            yTemp = yTemp+1;
            setGlobaly(yTemp);
            disp(getGlobaly);
        end
        if (strcmpi(keyPressed, 'downarrow'))
            yTemp = yTemp-1;
            setGlobaly(yTemp);
            disp(getGlobaly);
        end
    end