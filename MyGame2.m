%Resetting MATLAB environment
    close all;
    clear all;
    clc;
    
%Main program
%Note: Can't move up and down in Real Galaga...might change ours
%All the bullets have to be in the exact same while loop where they both will
%will be getting incremented and set and drew at the SAME TIME

    fig = figure('Color','black'); %Lets us use fig to reference our current figure
    global x; 
    global y;
    global ship;
    global count;
    global yBullet;
    global xBullet;
    global bullet;
    global enemy;
    global gameOver;
    global frames;
    x = 5; 
    y = 0;
    ship = plot(x,y,'*'); 
    count = 0;
    yBullet = [];
    xBullet = [];
    bullet = [];
    gameOver = false;
    frames = 0;
    title('Galaga Remix', 'Color', [0.5 0 0.5]);
    axis([0,10,0,10]);
    hold on %Keeps the axis the same when plotting/setting additional points
    set(gca,'Color','black'); 
    for i=1:4
        for j=2:8
            enemy(i,j) = plot(j,10-i,'x','Color','r'); %Enemy's are going to be plotted by row.
        end
    end
  
    goRight = true;
    while ~gameOver %While the game isn't over
        frames = frames + 1;
        set(fig,'KeyPressFcn',@getKeys); %Sets the figure so on a keypress, the function @getKeys runs
        %This block makes the enemies sway left and right
        lastShipX = get(enemy(:,size(enemy,2)), 'XData');
        lastShipXX = cell2mat(lastShipX); 
        firstShipX = get(enemy(:,2), 'XData');
        firstShipXX = cell2mat(firstShipX);
        for k = 1:size(lastShipXX)
            if (lastShipXX(k) == 10)
                goRight = false;
            end
        end
        for k = 1:size(firstShipXX)
            if (firstShipXX(k) == 0)
                goRight = true;
            end
        end
        if goRight
            for i=1:4
                for j=2:8
                    set(enemy(i,j),'XData', get(enemy(i,j),'XData')+1);                     
                end
            end
        else 
            for i=1:4
                for j=2:8
                    set(enemy(i,j),'XData', get(enemy(i,j),'XData')-1); 
                end
            end
        end
        %This block will select a random enemy
        randNum = randi([1 i],1);
        randNum = [randNum randi([2 j],1)];
        shooter = enemy(randNum(1), randNum(2));
        shooterCoords = get(shooter,'XData');
        shooterCoords = [shooterCoords get(shooter,'YData')-1];
        shooterFire = plot(shooterCoords(1), shooterCoords(2), 'v', 'Color', 'y');
        while shooterCoords(2) > 0
            set(shooterFire, 'YData', shooterCoords(2));
            drawnow;
            shooterCoords = shooterCoords - .02;
        end
        delete(shooterFire);
        
        pause(1);
        %disp(frames);
    end
    
    
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
        global yBullet
        yBullet = val;
    end
    
    function setBulletX(val)
        global xBullet
        xBullet = val;
    end
    
    function setBullet(val)
        global bullet
        bullet = val;
    end
    
%List of getters
    
    function xG = getGlobalx %Function used to get global variable
        global x
        xG = x;
    end
    
    function yG = getGlobaly
        global y
        yG = y;
    end
    
    function shipG = getShip
        global ship
        shipG = ship;
    end
    
    function countG = getCount
        global count
        countG = count;
    end
    
    function yBulletG = getBulletY
        global yBullet
        yBulletG = yBullet;
    end
    
    function xBulletG = getBulletX
        global xBullet
        xBulletG = xBullet;
    end
    
    function bulletG = getBullet
        global bullet
        bulletG = bullet;
    end    
    
    function enemyG = getEnemy
        global enemy
        enemyG = enemy;
    end
%List of functions
    
    function getKeys (fig,evt) %Returns the modifier and key pressed by user. Also moves the ship depending on what was pressed. May turn into seperate functions if turns too ugly.
        mod = evt.Modifier;
        keyPressed = evt.Key;
        xG = getGlobalx;
        yG = getGlobaly;
        shipG = getShip;
        countG = getCount;
        yBulletG = getBulletY;
        xBulletG = getBulletX;
        bulletG = getBullet;
        enemyG = getEnemy;
        if (strcmpi(keyPressed, 'leftarrow'))
            xG = xG-1;
            setGlobalx(xG);
            set(shipG, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'rightarrow'))
            xG = xG+1;
            setGlobalx(xG);
            set(shipG, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'uparrow'))
            yG = yG+1;
            setGlobaly(yG);
            set(shipG, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'downarrow'))
            yG = yG-1;
            setGlobaly(yG);
            set(shipG, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'space'))
            countG = countG + 1;
            bulletG(countG) = plot(getGlobalx, getGlobaly+1, '^'); %Plots the bullet once we press space
            yBulletG(countG) = get(bulletG(countG), 'YData'); %Should turn this into a 2x2 matrix that holds it's X and Y in one variable
            xBulletG(countG) = get(bulletG(countG), 'XData'); 
            fprintf('Shooting bullet Number %d\n', countG);
            setCount(countG);
            setBullet(bulletG);
            setBulletY(yBulletG);
            setBulletX(xBulletG);
            for i = 1:numel(yBulletG)
                if (yBulletG(i) ~= 10.25)
                fprintf('Iteration #:%d Moving from Y:%d\n', i, yBulletG(i)); 
                end
                while ((yBulletG(i) < 10.25) && (yBulletG(i) > 0))
                    yBulletG(i) = yBulletG(i) + .25;
                    set(bulletG(i), 'YData', yBulletG(i));
                    drawnow;
                    setBulletY(yBulletG);
                    %Under this is my hit detection test
                    %try
                     %   if (yBulletG(i)==get(enemy1G, 'YData') && xBulletG(countG)==get(enemy1G, 'XData') )
                      %      delete(enemy1G);
                      %  end
                   %catch
                        %disp('It cant find the deleted ship but who cares');
                    %end
                    %Going to write a try-catch-continue for now to ignore error message
                    %Need to re-wrire this all properly, but it does delete the object like I want.
                end
            end
        end
    end 