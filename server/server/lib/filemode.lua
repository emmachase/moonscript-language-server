local ffi = require("ffi")

local O_BINARY = 0x8000
local O_TEXT = 0x4000

ffi.cdef[[

typedef struct _iobuf
{
    char*   _ptr;
    int _cnt;
    char*   _base;
    int _flag;
    int _file;
    int _charbuf;
    int _bufsiz;
    char*   _tmpfname;
} FILE;

int _setmode (
   int fd,
   int mode
);

int _fileno(
   FILE *stream
);

int chdir(const char *path);
char *getcwd(char *buf, size_t size);

int fprintf(FILE *file, const char *format, ...);

int fflush(FILE *file);

int setbuf(FILE *file, char *buf);

int fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);

int ferror( FILE *stream );

void clearerr(FILE *stream);

]]

function setmode(stream, mode)
	if mode == "b" then
		ffi.C._setmode(ffi.C._fileno(stream), O_BINARY)
	else
		ffi.C._setmode(ffi.C._fileno(stream), O_TEXT)
	end
end

-- local function getWorkingDirectory()
--    return ffi.string(ffi.C.getcwd(nil, 0))
-- end

-- local function setWorkingDirectory(path)
--    return ffi.C.chdir(path)
-- end

-- Change the current working directory to the parent of the current file
-- ffi.C.setbuf(io.stdout, nil)

function puts(str)
   x = ffi.C.fwrite(str, 1, #str, io.stdout)
end

return {
   setmode = setmode,
   puts = puts
}
