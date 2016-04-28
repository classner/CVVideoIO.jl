using CVCore
using CVVideoIO
using Base.Test

@testset "video capture" begin
    cap = VideoCapture(0)
    @test isOpened(cap)
    release(cap)
    @test !isOpened(cap)
end
