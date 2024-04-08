function running = isAppRunning(appName)
    running = ~isempty(findall(0, 'Type', 'figure', 'Name', appName));
end