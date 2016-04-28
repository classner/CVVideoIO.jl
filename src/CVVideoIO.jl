module CVVideoIO

export VideoCapture, isOpened, release

using LibOpenCV
using CVCore
using Cxx

libopencv_videoio = LibOpenCV.find_library_e("libopencv_videoio")
try
    Libdl.dlopen(libopencv_videoio, Libdl.RTLD_GLOBAL)
catch e
    warn("You might need to set DYLD_LIBRARY_PATH to load dependencies proeprty.")
    rethrow(e)
end

cxx"""
#include <opencv2/videoio.hpp>
"""

typealias cvVideoCapture cxxt"cv::VideoCapture"
cvVideoCapture(idx::Int) = icxx"return cv::VideoCapture($idx);"

typealias VideoCapture cvVideoCapture

function Base.read(cap::VideoCapture)
    img = Mat{UInt8}()
    ok = icxx"$cap.read($(img.handle));"
    return ok, Mat(img.handle)
end

for f in [
        :grab,
        :isOpened,
        :release
        ]
    body = Expr(:macrocall, symbol("@icxx_str"), "\$cap.$f();")
    @eval $f(cap::VideoCapture) = $body
end

end # module
