rows = []
cells = []
q = ''

def notechoice(c)
  arp = [:C4, :F4, :G4, :C3]
  if c == "." #if cell is dead, play one of these notes
    use_synth :chiplead
    n = arp.sample
    play n, sustain: 1, release: 2, amp: 0.9
    sleep 1
  else #if cell is live, play this chord
    use_synth :chiplead
    play_chord arp, sustain: 2, release: 1
    sleep 3
  end
end

board = """put file path here"""

File.open(board,'r') do |thing|
  while q = thing.gets
    q.chomp
    rows << q.split #splits board into nested arrays of rows
  end
end

live_loop :ChordCityMelody do
  use_bpm 80
  i = 0
  while true
    rows[i].each {|c| notechoice(c)} #plays each note in a row, moves to next
    i += 1
    if i == rows.size
      i = 0 #loops back to beginning of board
    end
  end
end

live_loop :ChordCityBass do #continuous bass chords
  use_bpm 80
  use_synth :chipbass
  play_chord [:C3, :F3, :A3], sustain: 2, release: 1, amp: 0.8
  sleep 2
  play_chord [:C3, :F3, :A3], sustain: 2, release: 1, amp: 0.8
  sleep 2
  play_chord [:A2, :C3, :F3], sustain: 5, release: 1, amp: 0.8
  sleep 5
  play_chord [:G2, :C3, :E3], sustain: 5, release: 1, amp: 0.8
  sleep 5
  play_chord [:G2, :D3, :F3], sustain: 5, release: 1, amp: 0.8
  sleep 5
  play_chord [:F2, :A2, :D3], sustain: 5, release: 1, amp: 0.8
  sleep 5
end