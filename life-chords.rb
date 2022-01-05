rows = []
cells = []
q = ''
board = """put file path here"""
####
ns = {}
i = 0
n = 40
File.open(board,'r') do |thing|
  while q = thing.gets
    q.chomp
    rows << q.split #splits board into nested arrays of rows
    ns[i] = n #builds hash of board columns and corresponding notes
    i+=1
    n+=2
  end
end
####
i = 0
while i < rows.size #moves through board top to bottom
  j = 0
  livings = []
  while j< rows.size
    if rows[i][j] != '.'
      livings << ns[j] #constructs chord based on living cells
    end
    j += 1
  end
  if livings.size > 0 #prevents playing a nil chord
    play_chord livings
    sleep 1
  end
  i += 1
end