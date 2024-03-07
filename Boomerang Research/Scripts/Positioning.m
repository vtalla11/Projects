%Serial Connection
disp('Running...');
s = serial('COM3', 'BAUD', 115200); %COM port must be of listener device
fopen(s);
pause(0.5);
close();

%Path to saved data folder (will create two subfolders 'Data' and
%'Figures')
folderPath = 'C:\Users\timel\Projects\Boomerang Research'; %Change path for your own application

%Creating file names for data and figure
dataFolderInfo = dir(fullfile(folderPath,'Data'));
[N, ~] = size(dataFolderInfo);
for i = 3:N
parsedDataNames = strsplit(dataFolderInfo(i).name,{'_','.'});
fileNumArray(i) = str2double(char(parsedDataNames(2)));
end
fileNum = max(fileNumArray) + 1;
dataFileName = strcat('Data_',num2str(fileNum),'.txt');
fileID = fopen(fullfile(folderPath, 'Data', dataFileName), 'w');

%Initialization for main loop
anchorNames{1} = ' ';
initialAnchor = 1;
fwrite(s, [13 13]); %Use decimal values of ascii to write to device
while (~contains(anchorNames{1},'Help'))
  anchorNames{1} = fgetl(s);
end
fgetl(s);
fwrite(s, [108 101 115 13]);
fgetl(s);
closeFig = figure(1);
if (exist('BuildingFig.fig', 'file') == 2)
   fig = openfig('BuildingFig.fig');
else
  fig = figure(2);
end
pause(1);
h = animatedline('Color', 'b', 'Marker', 'o', 'MarkerFaceColor', 'b');
xlabel('X axis (m)'), ylabel('Y axis (m)'), zlabel('Z axis (m)'), title('Position relative to Anchor Initiator');
view(3);
grid on;
rotate3d on;

%Main loop
while ishghandle(closeFig)
  while s.BytesAvailable
    timeLine = strtok(fgetl(s), 13);
    positionLine = strtok(fgetl(s), 13);
    fgetl(s);
    parsedTimeLine = strsplit(timeLine, {'[',' '});
    [~, S] = size(parsedTimeLine);
    if (S ~= 5)
      fgetl(s);
      fgetl(s);
      continue;
    end
    parsedPositionLine = strsplit(positionLine, {' ','[', ','});
    [~, T] = size(parsedPositionLine);
      if (T ~= 8)
        continue;
      end
    tagName = char(parsedPositionLine(3));
    x = str2double(char(parsedPositionLine(4)));
    y = str2double(char(parsedPositionLine(5)));
    z = str2double(char(parsedPositionLine(6)));
    q = str2double(char(parsedPositionLine(7)));
    addpoints(h,x,y,z);
    fwrite(fileID, [tagName ',' char(parsedPositionLine(4)) ',' char(parsedPositionLine(5)) ',' char(parsedPositionLine(6)) ',' char(parsedPositionLine(7)) ',' char(parsedTimeLine(2)) 13 10]);
    drawnow;
    if (~ishghandle(closeFig))
      break;
    end
  end
end

%Clean up (saving figure, terminating serial connection, etc.)
fclose(fileID);
while (1)
  userInput = input('Save this data/figure: (Y/N) ', 's');
  if (strcmpi(userInput,'y') || strcmpi(userInput,'yes'))
    figureFileName = strcat('Figure_',num2str(fileNum),'.fig');
    savefig(fig,fullfile(folderPath,'Figures',figureFileName));
    close(fig);
    break;
  elseif (strcmpi(userInput,'n') || strcmpi(userInput,'no'))
    close(fig);
    delete(fullfile(folderPath,'Data',dataFileName));
    break;
  else
    disp('Try again.');
  end
end

%Properly disconnect serial device
disp('Ending...');
fwrite(s, 13);
pause(1);
fwrite(s, [113 117 105 116 13]);
pause(1);
flushinput(s);
fclose(s);
delete(s);
clear;
disp('Done');