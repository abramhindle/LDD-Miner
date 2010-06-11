all: bin-matrix.db

binlist:
	find /usr/bin/ -type f | rand | head -n 1000 > binlist

bin.db: binlist
	cat binlist | perl ldd-miner.pl > bin.db

bin-matrix.db: bin.db
	perl ldd-miner-to-matrix.pl bin.db > bin-matrix.db

clean:
	rm bin.db binlist bin-matrix.db || echo lol
