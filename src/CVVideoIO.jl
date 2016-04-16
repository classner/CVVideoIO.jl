module CVVideoIO

export VideoCapture, read, release

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

typealias VideoCapture cxxt"cv::VideoCapture"

VideoCapture(idx::Int) = icxx"cv::VideoCapture($idx);"

function Base.read(cap::VideoCapture)
    img = Mat{UInt8}()
    ok = icxx"cap->read(img.handle);"
    return ok, Mat(img.handle)
end

release(cap::VideoCapture) = icxx"$cap->release();"


end # module
