local M = {}

M.bgMusic = audio.loadStream("audio/song.mp3")
M.soundTable = {
    wall = audio.loadSound("audio/bounce.mp3"),
    bonus = audio.loadSound("audio/bonus.mp3"),
    exit = audio.loadSound("audio/exit.mp3"),
    evil = audio.loadSound("audio/evil.wav"),
    jump = audio.loadSound("audio/jump.mp3"),
    change = audio.loadSound("audio/uh.wav")
}








return M