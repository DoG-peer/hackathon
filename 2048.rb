# coding : SJIS
EMPTY = 'e'
SIZE = 4

def short(ar)
  ar.select{|x|x!=EMPTY}
end

#‹ó”’‚ª‚È‚¢‚Æ‚«‚Ìmove
def move_as_short(ar)
  if ar.length < 2
    return ar
  elsif ar[0] == ar[1]
    return [ar[0]+ar[1]] + move_as_short(ar[2..-1])
  else
    return [ar[0]] + move_as_short(ar[1..-1])
  end
end

#‹ó”’‚ª‚ ‚é‚Æ‚«‚Ìmove
def move_unbounded(ar)
  move_as_short(short(ar))
end

def move(ar)
  y = move_unbounded(ar)
  if y.length >= SIZE
    return y[0...SIZE]
  else
    return y + Array.new(SIZE - y.length,EMPTY)
  end
    
end

def move_with_flag(ar)
  after = move(ar)
  return [after, ar != after]
end

class GameState
  attr_accessor :game
  def initialize(ar=Array.new(SIZE**2,EMPTY))
    @state = ar
    @empties = (0...(SIZE**2)).to_a
    @width = 5
    @game = 'start'
  end

  def show
    #system 'cls'
    puts "+#{ ('-' * (@width) + '+') * SIZE }"
    SIZE.times do |i|
      SIZE.times do |j|
        v = @state[i*SIZE+j]
        if v == EMPTY
          print "|" + " " * @width
        else
          print "l" + " " * (@width - (v.to_s).length - 1) + v.to_s + " "
        end
      end
      puts "|"
      puts "+#{ ('-' * (@width) + '+') * SIZE }"
    end
  end

  def popup
    if @empties.empty?
      puts 'GAME OVER'
      @game = 'end'
    else
      pos = @empties.sample
      @empties.delete(pos)
      @state[pos] = (rand(10)==0)?4:2
    end
  end
  
  def move_and_its_result
    true
  end
end

#ar = [2, 'e', 2 ,'e']
#ar2 = [2,4,8,16]

#p move_with_flag(ar)
#p move_with_flag(ar2)

x = GameState.new
x.popup
x.popup
#2‚Ü‚·‚Ù‚Ç•\Ž¦
until x.game == 'end' do
  x.show
  redo unless x.move_and_its_result
  x.popup
end
