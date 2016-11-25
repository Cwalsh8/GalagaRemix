%Resetting MATLAB environment
    close all;
    clear all;
    clc;
    
%Main program
%Note: Can't move up and down in Real Galaga...might change ours
%Need to properly delete the bullets to prevent memory leaks
%Then work on hit detection.

    fig = figure('Color','black'); 
    global x; 
    global y;
    global ship;
    global count;
    global bullet;
    global enemy;
    global gameOver;
    global frames;
    global shooterFire;
    x = 5; 
    y = 0;
    ship = plot(x,y,'*'); 
    count = 0;
    bullet = [];
    shooterFire = [];
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
  
    goRight = true; %Enemies start off moving to the Right
    num = 0;
    while ~gameOver %Main game loop
        frames = frames + 1;
        set(fig,'KeyPressFcn',@getKeys); %Sets the figure so on a keypress, the function @getKeys runs
        
        %This block makes the enemies sway left and right
        if (mod(frames,8) == 0)
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
        end
        
        %This block will select a random enemy every 10 frames
        if (mod(frames,30) == 0 || frames == 1)
            num = num + 1;
            randNum = randi([1 i],1);
            randNum = [randNum randi([2 j],1)];
            shooter = enemy(randNum(1), randNum(2));
            shooterCoords = get(shooter,'XData');
            shooterCoords = [shooterCoords get(shooter,'YData')-1];
            shooterFire(num) = plot(shooterCoords(1), shooterCoords(2), 'v', 'Color', 'y');
        end
        
        %This sets up the bullets position in the next frames, then draws it
        for o = 1:length(shooterFire)
            if ~isnan(shooterFire(o))
                set(shooterFire(o), 'YData', get(shooterFire(o), 'YData') - .1);
                if (get(shooterFire(o), 'YData') < 0)
                    shooterFire(o) = NaN;
                    disp(shooterFire(:));
                end
            end
        end
        for p = 1:length(bullet)
            if ~isnan(bullet(p))
                set(bullet(p), 'YData', get(bullet(p), 'YData') + .1);
                if (get(bullet(p), 'YData') > 10)
                    bullet(p) = NaN;
                    disp(bullet(:));
                end
            end
        end
        drawnow;
        
        %This pause controls how fast the game loop
        pause(.05); 
    end
    
    
%List of setters
 
    function setGlobalx(val) 
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
    
    function setBullet(val)
        global bullet
        bullet = val;
    end
    
%List of getters
    
    function xG = getGlobalx 
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
    
    function bulletG = getBullet
        global bullet
        bulletG = bullet;
    end    
    
    function enemyG = getEnemy
        global enemy
        enemyG = enemy;
    end
    
%List of functions
    
    %Returns the modifier and key pressed by user. 
    %Also moves the ship depending on what was pressed. 
    function getKeys (fig,evt)
        mod = evt.Modifier;
        keyPressed = evt.Key;
        xG = getGlobalx;
        yG = getGlobaly;
        shipG = getShip;
        countG = getCount;
        bulletG = getBullet;
        if (strcmpi(keyPressed, 'leftarrow'))
            if ( xG > 0 )
                xG = xG-1;
            end
            setGlobalx(xG);
            set(shipG, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'rightarrow'))
            if ( xG < 10 )
                xG = xG+1;
            end
            setGlobalx(xG);
            set(shipG, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'uparrow'))
            if ( yG < 10 )
                yG = yG+1;
            end
            setGlobaly(yG);
            set(shipG, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'downarrow'))
            if ( yG > 0 )
                yG = yG-1;
            end
            setGlobaly(yG);
            set(shipG, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'space'))
            countG = countG + 1;
            bulletG(countG) = plot(getGlobalx, getGlobaly+1, '^', 'Color', 'blue');
            setCount(countG);
            setBullet(bulletG);
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
                %end
            %end    
        end
    end 