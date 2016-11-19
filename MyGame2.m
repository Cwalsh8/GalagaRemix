%Resetting MATLAB environment
    close all;
    clear all;
    clc;
%Main program
    fig = figure; %Lets us use fig to reference our current figure
    global x; %Sets x as a global variable
    global y;
    global ship;
    setGlobalx(5); %Sets the value of x using the function at the bottom
    setGlobaly(2);
    ship = plot(x,y,'*'); %Plots x and y, using the star design.
    title('Galaga Remix');
    axis([0,10,0,10]);
    set(fig,'KeyPressFcn',@getKeys); %Sets the figure so on a keypress, the function @getKeys runs
    hold on %Keeps the axis the same when adding additional points
    
 %What I have to do next
 %Make bullet an Array so multiple bullets can scale across the screen at once
 
 
%List of setters
 
    function setGlobalx(val) %Function used to set global variable
        global x
        x = val;
    end
    
    function setGlobaly(val)
        global y
        y = val;
    end
    
%List of getters
    
    function xTemp = getGlobalx %Function used to get global variable
        global x
        xTemp = x;
    end
    
    function yTemp = getGlobaly
        global y
        yTemp = y;
    end
    
    function shipTemp = getShip
        global ship;
        shipTemp = ship;
    end
%List of functions
    
    function getKeys (fig,evt) %Returns the modifier and key pressed by user. Also moves the ship depending on what was pressed. May turn into seperate functions if turns too ugly.
        mod = evt.Modifier;
        keyPressed = evt.Key;
        disp(keyPressed);
        xTemp = getGlobalx;
        yTemp = getGlobaly;
        shipTemp = getShip;
        if (strcmpi(keyPressed, 'leftarrow'))
            xTemp = xTemp-1;
            setGlobalx(xTemp);
            set(shipTemp, 'XData', getGlobalx, 'YData', getGlobaly);
            disp(getGlobalx);
        end
        if (strcmpi(keyPressed, 'rightarrow'))
            xTemp = xTemp+1;
            setGlobalx(xTemp);
            set(shipTemp, 'XData', getGlobalx, 'YData', getGlobaly);
            disp(getGlobalx);
        end
        if (strcmpi(keyPressed, 'uparrow'))
            yTemp = yTemp+1;
            setGlobaly(yTemp);
            set(shipTemp, 'XData', getGlobalx, 'YData', getGlobaly);
            disp(getGlobaly);
        end
        if (strcmpi(keyPressed, 'downarrow'))
            yTemp = yTemp-1;
            setGlobaly(yTemp);
            set(shipTemp, 'XData', getGlobalx, 'YData', getGlobaly);
            disp(getGlobaly);
        end
        if (strcmpi(keyPressed, 'space'))
            inc = 1;
            bullet = plot(getGlobalx,(getGlobaly+inc), '^');
            bulletY = getGlobaly+inc;
            while ((bulletY) < 10.25)
                disp('IN THE WHILE LOOP');
                set(bullet, 'YData', (bulletY));
                drawnow
                bulletY = bulletY + .02;
            end
        end
    end