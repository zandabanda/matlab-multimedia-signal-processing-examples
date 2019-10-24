function run( data_path )

rundir = pwd;
mkdir IMAGES; cd IMAGES; dir1 = pwd; cd ..;

cd(data_path); 
copyfile('IMAGES',dir1);
copyfile('databaseInfo.mat',rundir);
cd(rundir);

cbirMP;

end

