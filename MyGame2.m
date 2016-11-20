%Resetting MATLAB environment
    close all;
    clear all;
    clc;
%Main program
    fig = figure; %Lets us use fig to reference our current figure
    global x; %Sets x as a global variable
    global y;
    global ship;
    global count;
    global bulletY;
    global bullet;
    setGlobalx(5); %Sets the value of x using the function at the bottom
    setGlobaly(2);
    setCount(0);
    setBulletY([]);
    setBullet([]);
    ship = plot(x,y,'*'); %Plots x and y, using the star design.
    title('Galaga Remix');
    axis([0,10,0,10]);
    set(fig,'KeyPressFcn',@getKeys); %Sets the figure so on a keypress, the function @getKeys runs
    hold on %Keeps the axis the same when adding additional points
    
 %What I have to do next
 %Make bullet an Array so multiple bullets can scale across the screen at once
 %-Multiple bullets still a problem
 
 
%List of setters
 
    function setGlobalx(val) %Function used to set global variable
        global x
        x = val;
    end
    
    function setGlobaly(val)
        global y
        y = val;
    end
    
    function setCount(val)
        global count
        count = val;
    end
    
    function setBulletY(val)
        global bulletY
        bulletY = val;
    end
    
    
    function setBullet(val)
        global bullet
        bullet = val;
    end
    
%List of getters
%Should be able to merge these all into one function
%One giant globalTemp = getGlobals; have them all in a list or something
    
    function xTemp = getGlobalx %Function used to get global variable
        global x
        xTemp = x;
    end
    
    function yTemp = getGlobaly
        global y
        yTemp = y;
    end
    
    function shipTemp = getShip
        global ship
        shipTemp = ship;
    end
    
    function countTemp = getCount
        global count
        countTemp = count;
    end
    
    function bulletYTemp = getBulletY
        global bulletY
        bulletYTemp = bulletY;
    end
    
    function bulletTemp = getBullet
        global bullet
        bulletTemp = bullet;
    end    
%List of functions
    
    function getKeys (fig,evt) %Returns the modifier and key pressed by user. Also moves the ship depending on what was pressed. May turn into seperate functions if turns too ugly.
        mod = evt.Modifier;
        keyPressed = evt.Key;
        xTemp = getGlobalx;
        yTemp = getGlobaly;
        shipTemp = getShip;
        countTemp = getCount;
        bulletYTemp = getBulletY;
        bulletTemp = getBullet;
        if (strcmpi(keyPressed, 'leftarrow'))
            xTemp = xTemp-1;
            setGlobalx(xTemp);
            set(shipTemp, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'rightarrow'))
            xTemp = xTemp+1;
            setGlobalx(xTemp);
            set(shipTemp, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'uparrow'))
            yTemp = yTemp+1;
            setGlobaly(yTemp);
            set(shipTemp, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'downarrow'))
            yTemp = yTemp-1;
            setGlobaly(yTemp);
            set(shipTemp, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'space'))
            countTemp = countTemp + 1;
            bulletTemp(countTemp) = plot(getGlobalx, getGlobaly+1, '^'); %Plots the bullet once we press space
            bulletYTemp(countTemp) = get(bulletTemp(countTemp), 'YData');
            fprintf('Shooting bullet Number %d\n', countTemp);
            setCount(countTemp);
            setBullet(bulletTemp);
            setBulletY(bulletYTemp);
            for i = 1:numel(bulletYTemp)
                if (bulletYTemp(i) ~= 10.25)
                fprintf('Iteration #:%d Moving from Y:%d\n', i, bulletYTemp(i));
                end
                while ((bulletYTemp(i) < 10.25) && (bulletYTemp(i) > 0))
                    bulletYTemp(i) = bulletYTemp(i) + .25;
                    set(bulletTemp(i), 'YData', bulletYTemp(i));
                    drawnow;
                    setBulletY(bulletYTemp);
                end
            end
        end
    end 