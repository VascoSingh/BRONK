z=AllDataTest;
lv = max(cellfun(@length,z));
za = z{1}{1};
za{1,:}=0;
for idx = 1:length(z)
    cellVal = z{idx};
  if length(cellVal) < lv
      for idy =(length(cellVal)+1):lv
          z{idx}{idy} = za;
      end
  end
end
