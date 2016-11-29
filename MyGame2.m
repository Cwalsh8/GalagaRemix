%Resetting MATLAB environment
    close all;
    clear all;
    clc;
    
%Main program

    fig = figure('Color','black');  %Creates the figure with a black background
    
    %Creates global variables for use inside functions as well as outside functions
    
    global x; 
    global y;
    global ship;
    global count;
    global bullet;
    global enemy;
    global gameOver;
    global frames;
    global shooterFire;
    
    %Initializing global variables
    
    x = 5; 
    y = 1;
    ship = plot(x,y,'*','Color','green'); 
    count = 0;
    bullet = [];
    shooterFire = [];
    gameOver = false;
    frames = 0;
    
    
    title('Galaga Remix','Color',[0.5 0 0.5]);
    axis([0,10,0,10]); %Sets each axis from 0 to 10.
    hold on %Keeps the axis in the same position when plotting points
    set(gca,'Color','black'); %Makes current axes black
    
    
    %Turns off the unnessecary graph items for this game
    
    box off;
    set(gca,'xcolor',get(gcf,'color')); 
    set(gca,'xtick',[]);
    set(gca,'ycolor',get(gcf,'color'));
    set(gca,'ytick',[])
    
    %Plots all the enemies into their intial places.
    
    for i=1:4
        for j=2:8
            enemy(i,j) = plot(j,10-i,'x','Color','r'); 
        end
    end
  
    goRight = true; %Boolean to check if enemies should move left or right 
    num = 0; %count for keeping track of enemy ship array
    
    %Main game loop, 
    %Each loop through represents a frame
    
    while ~gameOver 
        frames = frames + 1; 
        xlabel({'Score:';(100000-frames)},'Color',[0.5 0 0.5]);
        set(fig,'KeyPressFcn',@getKeys); %Sets the figure so on a keypress, the function @getKeys runs
        
        %This block makes the enemies sway left and right
        
        if (mod(frames,32) == 0)
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
                test = 0;
                for i=1:4
                    for j=2:8
                        set(enemy(i,j),'XData', get(enemy(i,j),'XData')+1);
                        if get(enemy(i,j),'YData') == -10
                            test = test + 1;
                            if test == 28
                                gameOver = true;
                                text(4.2,5,'Congratulations!','Color','y','FontSize',25);
                                [t, Fs] = audioread('coin_credit.wav');
                                sound(t, Fs);
                            end
                        end
                    end
                end
            else 
                test = 0;
                for i=1:4
                    for j=2:8
                        set(enemy(i,j),'XData', get(enemy(i,j),'XData')-1); 
                        if get(enemy(i,j),'YData') == -10
                            test = test + 1;
                            if test == 28
                                gameOver = true;
                                text(4.2,5,'Congratulations!','Color','y','FontSize',25);
                                [t, Fs] = audioread('coin_credit.wav');
                                sound(t, Fs);
                            end
                        end
                    end
                end
            end
        end
        
        %This block will select a random enemy to shoot every 20-40 frames
        
        randFire = randi([20,40],1); 
        if (mod(frames,randFire) == 0 || frames == 1)
            num = num + 1;
            randNum = randi([1 i],1);
            randNum = [randNum randi([2 j],1)];
            shooter = enemy(randNum(1), randNum(2));
            shooterCoords = get(shooter,'XData');
            shooterCoords = [shooterCoords get(shooter,'YData')-1];
            shooterFire(num) = plot(shooterCoords(1), shooterCoords(2), 'v', 'Color', 'y');
        end
        
        %This block sets up our enemies' bullets position for the next frame
        
        for o = 1:length(shooterFire)
            if ~isnan(shooterFire(o))
                a = get(shooterFire(o), 'YData');
                z = get(shooterFire(o), 'XData');
                set(shooterFire(o), 'YData', a - .1);
                if eq(single(a), single(y)) && eq(single(z),single(x)) 
                    xlabel({'Score:';0},'Color',[0.5 0 0.5]);
                    gameOver = true;
                    text(4.2,5,'GAME OVER','Color','red','FontSize',25);
                    [t, Fs] = audioread('fighter_destroyed.wav');
                    sound(t, Fs);
                elseif a < -1
                    shooterFire(o) = NaN;
                end
            end
        end
        
        %This block sets up our bullets position for the next frame
        
        
        for p = 1:length(bullet)
            if ~isnan(bullet(p))
                b = get(bullet(p), 'YData');
                c = get(bullet(p), 'XData');
                set(bullet(p), 'YData', get(bullet(p), 'YData') + .25);
                for m=1:4
                    for n=2:8
                        q = get(enemy(m,n), 'YData');
                        r = get(enemy(m,n), 'XData');
                        if eq(single(q), single(b)) && eq(single(c), single(r))
                            %TEMPORARY THROW ENEMY OFF SCREEN
                            set(enemy(m,n), 'YData', -10);
                            set(bullet(p), 'XData', 30);
                            [t, Fs] = audioread('explosion.wav');
                            sound(t, Fs);
                        end
                    end
                end
                if (get(bullet(p), 'YData') > 10)
                    bullet(p) = NaN;
                end          
            end
        end
        
        %At the end of each frame, it draws all the new positions of each object at once.
        drawnow;
        
        %This pause controls how fast the game iterates through all these operations.
        pause(.005);
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
    
%List of functions
    
    %Returns the key pressed by user. 
    %Also moves the ship/plot bullets depending on what was pressed.
    
    function getKeys (fig,evt)
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
            if ( yG > 1 )
                yG = yG-1;
            end
            setGlobaly(yG);
            set(shipG, 'XData', getGlobalx, 'YData', getGlobaly);
        end
        if (strcmpi(keyPressed, 'space'))
            countG = countG + 1;
            bulletG(countG) = plot(getGlobalx, getGlobaly+1, '^', 'Color', 'cyan');
            setCount(countG);
            setBullet(bulletG);
            [t, Fs] = audioread('laser_widebeam.wav');
            sound(t, Fs);
        end
    end 