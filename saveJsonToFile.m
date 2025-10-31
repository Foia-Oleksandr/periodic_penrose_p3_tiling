function saveJsonToFile(jsonStr, filename)

fid = fopen(filename, 'w');
fprintf(fid, '%s', jsonStr);
fclose(fid);
end