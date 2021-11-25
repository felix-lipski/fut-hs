scf4: luser
	alacritty --hold --command ./luser

scf5:
	echo "scf5"

dotprod.h: dotprod.fut
	futhark opencl --library dotprod.fut

luser: luser.hs dotprod.h test.c test.h
	ghc luser.hs -L$(LD_LIBRARY_PATH) -lOpenCL dotprod.h test.h dotprod.c test.c

clean:
	rm *.o exe dotprod.h dotprod.c dotprod dotprod.json libdotprod.so luser *.hi
