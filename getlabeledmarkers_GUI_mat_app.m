  function [Markers, Labels, Gaps, start, ende, freq, ftkratio, nframes, Markerarray] = getlabeledmarkers_GUI_mat_app(Pfad)
        %         tmpName = split(Pfad, '\');
        mainStruct = [];
        
        mainStruct = load(Pfad);
        name = string(fieldnames(mainStruct));
        
        freq = mainStruct.(name).FrameRate;
        
       % ftkratio = mainStruct.(name).Force.Frequency/mainStruct.(name).FrameRate;
        fkf = mainStruct.(name).Force.Frequency;
        fkk = mainStruct.(name).FrameRate;
        ftkratio=  fkf/fkk; 
        start = mainStruct.(name).StartFrame;
        
        %end umschreiben in frames die genommen werden von dem File
        %(berechnen)
        ende = start + mainStruct.(name).Frames - 1;
        nframes = mainStruct.(name).Frames;
        
        n_labels = mainStruct.(name).Trajectories.Labeled.Count;
        
        Labels = mainStruct.(name).Trajectories.Labeled.Labels';
        
        for n = 1:length(Labels)
            Markers.(Labels{n}).data = squeeze(mainStruct.(name).Trajectories.Labeled.Data(n, 1:3, :));
            MarkerarryCell{1,n} =  Markers.(Labels{n}).data';
        end
        Markerarray = cell2mat(MarkerarryCell);
        Gaps = 0;
  end