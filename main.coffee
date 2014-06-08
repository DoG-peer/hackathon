enchant()
#もうアイテムだけいじっておわりにするか
item_list={
      a: [
        "ruby",
        "C#",
        "C++"
        "JavaScript",
        "TypeScript",
        "CoffeeScript",
        "HSP",
        "PHP",
        "CakePHP"
        "Java",
        "swift",
        "Flash",
        "HTML5",
        "Unity",
        "独自言語",
        "ActionScript"
      ]
      b: [
        "vim",
        "emacs",
        "メモ帳",
        "FlashDevelop",
        ".NetFramework",
        "node.js",
        "AWS",
        "VisualStudio",
        "DXライブラリ",
        "Rails",
        "enchant.js",
        "すたちゅー",
        "愛と勇気",
        "Git",
        "Silverlight",
        "TwitterBootstrap"
      ]
      c: [
        "シューティングゲームを作る",
        "放置ゲーを作る",
        "ウェブアプリを作る",
        "iPhoneアプリを作る",
        "便利なソフトを作る"
        "にぎやかしをする",
        "お絵かきをする",
        "共同開発する"
      ]
    }


window.onload = ->
  game = new Game(640,480)
  game.fps = 30
  game.preload 'img/hana.png',
    'img/gameover.png',
    'img/clear.png',
    'img/chara1.png',
    'img/effect0.png',
    'img/hand.png',
    'img/graphic.png',
    'img/jungle.png',
    'sound/bgm_open.mp3',
    'sound/bgm_game.mp3',
    'sound/bgm_dead.mp3',
    'sound/bgm_end.mp3',
    'sound/explosion.wav',
    'sound/escape.wav',
    'sound/item.wav',
    'sound/shoot.wav'
  console.log '読み込み完了'
  game.keybind(90, 'a')
  game.keybind(88, 'b')
    #zがaボタン

  game.onload = ->
    scenes = {
      open : new Scene()
      game : new Scene()
      dead : new Scene()
      end : new Scene()
    }
    bgs = {
      open : "white"
      game : "red"
      dead : "black"
      end : "green"
    }
    
    class GameScene
      constructor: (name) ->
        @name = name
        @scene = scenes[name]
        @scene.backgroundColor = bgs[name]
        @bgm = game.assets["sound/bgm_#{name}.mp3"]
        #@bgm.volume = 0.2
        @scene.addChild @bgm

      stop: () ->
        @bgm.stop()

      #前のものを止めて次を再生
      start: ()->#temp) ->
        #temp.stop()
        game.replaceScene @scene
        @bgm.currentTime = 0
        @bgm.play()
        #@bgm.src.loop = true

      first_start: () ->
        console.log this
        game.pushScene @scene
        @bgm.play()
        #@bgm.src.loop = true

      add: (obj) ->
        @scene.addChild obj
      on: (str, fun) ->
        @scene.on(str,fun)
    game_scenes = {
      open : new GameScene("open")
      game : new GameScene("game")
      dead : new GameScene("dead")
      end : new GameScene("end")
    }
#ループしないか･･･
  #仮設ボタン
    ###
    class Btn
      constructor: (name,t) ->
        @obj = new Label()
        @obj.text = name
        @obj.font = "32px"
        @obj.color = "yellow"
        @obj.x = 200 + rand(100)
        @temp = t
        @obj.ontouchstart = () ->
          game_scenes[t].stop()
          game_scenes[name].start()
    btn_o2g = new Btn("game","open")
    btn_g2d = new Btn("dead","game")
    btn_g2e = new Btn("end","game")
    btn_d2o = new Btn("open","dead")
    btn_e2o = new Btn("open","end")

    game_scenes["open"].add btn_o2g.obj
    game_scenes["game"].add btn_g2d.obj
    game_scenes["game"].add btn_g2e.obj
    game_scenes["dead"].add btn_d2o.obj
    game_scenes["end"].add btn_e2o.obj    
    #ここまで仮設ボタン
    ###
    hana = new Sprite(160,160)
    hana.x = 240
    hana.y = 250
    hana.image = game.assets["img/hana.png"]
    game_scenes["open"].add hana

    game_over = new Sprite(189,97)
    game_over.x = 230
    game_over.y = 250
    game_over.image = game.assets["img/gameover.png"]
    game_scenes["dead"].add game_over
    
    clear = new Sprite(267,48)
    clear.x = 190
    clear.y = 250
    clear.image = game.assets["img/clear.png"]
    game_scenes["end"].add clear
    
    class Player
      constructor: () ->
        @sprite = new Sprite(32,32)
        @sprite.x = 600
        @sprite.y = 300
        @sprite.image = game.assets["img/chara1.png"]
        @hp = 1
        @items = {}
        @sprite.on "enterframe", ->
          this.x -= 3
          if game.input.up
            this.y -= 5
            if this.y < -14
              this.y = -14
          if game.input.down
            this.y += 5
            if this.y > 480
              this.y = 480
          if game.input.right
            this.scaleX = 1
            this.x += 5
            if this.x > 630
              this.x = 630
          if game.input.left
            this.scaleX = -1
            this.x -= 5

      shoot: () ->
        d = @sprite.scaleX
        b = new Bullet(@sprite.x + 5 + 15*d ,@sprite.y + 8, d)
        sound = game.assets['sound/shoot.wav']
        #sound.volume = 0.5
        sound.currentTime = 0
        sound.play()
        b
      damaged: (i) ->
        @hp -= i
      init: () ->
        @sprite.x = 600
        @sprite.y = 300
        @hp = 1
        @items = {}
      die: () ->
        init()
        game_scenes["game"].stop()
        game_scenes["dead"].start()
      clear: () ->
        game.assets['sound/escape.wav'].play()
        clear_label.text = "「彼」の誘いを逃れるため，" + player.items["a"] + "で" + player.items["b"] + "を使って" + player.items["c"] + "ことに決めました．"
        document.getElementById("score").innerHTML = clear_label.text
        ###
        document.getElementById("twitter_btn").dataset.text = clear_label.text
        d = document
        s = 'script'
        id = 'twitter-wjs'
        js=d.getElementsByTagName(s)[0][0]
        fjs= d.getElementsByTagName(s)[0][1]
        if /^http:/.test(d.location)
          p = 'http'
        else
          p = 'https'
        if !d.getElementById(id)
          js=d.createElement(s)
          js.id=id
          js.src=p+'://platform.twitter.com/widgets.js'
          fjs.parentNode.insertBefore(js,fjs)
        ###
        game_scenes["game"].stop()
        game_scenes["end"].start()

    class Bullet
      ##x,y:位置, d:方向（1が右, -1が左）
      constructor: (x,y,d) ->
        @sprite = new Sprite(16,16)
        @sprite.x = x
        @sprite.y = y
        @sprite.image = game.assets["img/graphic.png"]
        @sprite.frame = 13
        @sprite.rotation = 90 * d
        game_scenes["game"].add @sprite
        @sprite.on 'enterframe', ->
          this.x += 5 * d
          hit_hands = false
          for hand in hands
            if this.intersect hand.sprite
              hit_hands = true
              break
          if this.intersect(jungle)
            explosion(this.x+8 ,this.y+ 8)
            jungle_hp -= 1
            this.parentNode.removeChild(this)
            if jungle_hp <= 0
              i = new Item(this.x,this.y)
              jungle_recovery()
          else if hit_hands
            explosion(this.x+8 ,this.y+ 8)
            this.parentNode.removeChild(this)

      hit: () ->
        this.destroy()
      destroy: () ->
        @sprite.parentNode.removeChild(@sprite)
      
    class Hand
      constructor: (h) ->
        @sprite = new Sprite(640,80)
        @sprite.image = game.assets['img/hand.png']
        @pos_x = rand(100) - 350
        @pos_y = h
        @shift = rand(10)
        @sprite.x = @pos_x
        @sprite.y = @pos_y
        @sprite.on 'enterframe', ->
          if this.intersect player.sprite
            player.die()
        game_scenes["game"].add @sprite

      move: () ->
        t = this.sprite.age + this.shift
        this.sprite.x = this.pos_x + 100 * Math.sin(t * 0.05)
        this.sprite.y = this.pos_y + 70 * Math.sin(t * 0.1)
        this.sprite.rotation = 30 * Math.sin(t * 0.5)

      init: () ->
        this.sprite.x = this.pos_x
        this.sprite.y = this.pos_y

    circle = new Surface(32,32)
    circle.context.beginPath()
    circle.context.fillStyle = 'yellow'
    circle.context.arc(16,16,16,0,Math.PI*2,true)
    circle.context.fill()
    
    ball = new Surface(32,32)
    ball.context.beginPath()
    ball.context.arc(16,16,16,0,Math.PI*2,true)
    ball.context.fill()

    items = []
    class Item
      constructor: (x,y)->
        @kind = ["a","b","c"][rand(3)]
        l = item_list[@kind].length
        @label = new Label()
        @label.font = "bold 100% \"メイリオ\""
        @label.x = x
        @label.y = y + 5
        @label.text = item_list[@kind][rand(l)]
        @label.color = "blue"
        #@label.backgroundColor = "yellow"
        val = [@kind, @label.text]
        
        @sprite = new Sprite(32,32)
        @sprite.image = circle
        @sprite.x = x
        @sprite.y = y
        game_scenes["game"].add @sprite
        game_scenes["game"].add @label
        @label.on 'enterframe', ->
          this.x += 3
        @sprite.on 'enterframe', ->
          this.x += 3
          if this.intersect(player.sprite)
            sound_item = game.assets['sound/item.wav']
            #sound_item.volume = 0.5
            sound_item.currentTime = 0
            sound_item.play()
            player.items[val[0]] = val[1]
            console.log player.items
            this.parentNode.removeChild(this)
            if player.items["a"] != undefined && player.items["b"] != undefined && player.items["c"] != undefined
              player.clear()
        
        items.push this
      destroy: () ->
        if @sprite != undefined && @sprite.parentNode != undefined && @sprite.parentNode != null
          @sprite.parentNode.removeChild(@sprite)
        @label.parentNode.removeChild(@label)
    effects = []
    explosion = (x,y) ->
      effect = new Sprite(16,16)
      effect.x = x
      effect.y = y
      effect.frame = 0
      effect.image = game.assets['img/effect0.png']
      effects.push effect
      game_scenes["game"].add effect
      sound = game.assets['sound/explosion.wav']
      #sound.volume = 0.5
      sound.currentTime = 0
      sound.play()

      effect.on 'enterframe', ->
        if this.age > 20
          this.parentNode.removeChild(this)
        else
          this.frame = this.age / 4
    delete_all_effects = ->
      #console.log effects
      for eff in effects
        if eff != undefined && eff.parentNode != undefined && eff.parentNode != null
          eff.parentNode.removeChild(eff)
      effects = []
    #プレーヤー
    player = new Player()
    game_scenes["game"].add player.sprite
    init = ->
      game_scenes["open"].scene.backgroundColor = "white"
      player.init()
      hands[0].init()
      hands[1].init()
      delete_all_bullets()
      delete_all_items()
      delete_all_effects()
      jungle_recovery()
    #壁
    jungle = new Sprite(150,480)
    jungle_hp = 2
    jungle.image = game.assets['img/jungle.png']
    jungle.on 'enterframe', ->
      if this.intersect(player.sprite)
        player.die()
    game_scenes["game"].add jungle
    jungle_recovery = ->
      jungle_hp = 50
    #手
    hands = [ new Hand(100), new Hand(300)]
    #ball
    
    class Ball
      constructor: (h) ->
        @sprite = new Sprite(32,32)
        @sprite.image = ball
        @sprite.x = 120 + rand(30)
        @sprite.y = h + rand(20)
        @scale = 1
        game_scenes["game"].add @sprite
   
      move: (t)->
        @sprite.scale((0.2 * (t+3))/@scale, (0.2 * (t+3))/@scale)
        @scale = 0.2 * (t+3)
    balls = []
    for i in [0...11]
      balls.push new Ball(40*(i+1))
    #弾
    bullets = []
    delete_all_bullets = ->
      for bullet in bullets
        if bullet != undefined  && bullet.sprite != undefined && ( bullet.sprite.parentNode != undefined) && (bullet.sprite.parentNode != null)
          bullet.destroy()
      bullets = []
    game_scenes["game"].on 'abuttondown', ->
      bullets.push player.shoot()
    
    game_scenes["game"].on 'enterframe', ->
      hands[0].move()
      hands[1].move()
      for i in [0...11]
        balls[i].move(rand(4))
      if game_scenes["game"].bgm.currentTime >= 70
         game_scenes["game"].bgm.currentTime = 0
    
    #アイテム
    delete_all_items = ->
      #console.log items
      for item in items
        if item != undefined
          item.destroy()
      items = []

    story_label = (val) ->
      lab = new Label()
      lab.text = val
      lab.x = 100
      lab.y = 100
      lab.font = "150%/200% \"メイリオ\""
      lab

    center_label = (val,size) ->
      lab = new Label()
      lab.text = val
      lab.x = 200
      lab.y = 400
      lab.font = "#{size}%/150% \"メイリオ\""
      lab
    #open
    open_label = story_label("ハッカソンだよ～")
    game_scenes["open"].add open_label

    game_scenes["open"].add center_label("zキーを押してスタート",200)

    node = new Node
    node.on 'enterframe', ->
      if this.age > 100
        this.age = 0
        this.parentNode.removeChild(this)
        init()
        open_label.text = "ハッカソンだよ～"
        game_scenes["open"].stop()
        #gameの初期化をする
        game_scenes["game"].start()
    
    game_scenes["open"].on 'abuttondown', ->
      this.backgroundColor = "deeppink"
      open_label.text = "やあ<br>  ？？？「僕と一緒に開発しよう<br>    ふひっふひひぃひ」"
      game_scenes["open"].add node


    #dead
    dead_label = story_label("あなたは捕まってしまった<br>  「彼」のもとで奴隷として<br>      開発することになりました")
    dead_label.color = "yellow"
    game_scenes["dead"].add dead_label
    restart_label = center_label("xボタンで戻る",200)
    restart_label.color = "yellow"
    restart_label.x += 45
    game_scenes["dead"].add restart_label
    game_scenes["dead"].on 'bbuttondown', ->
      game_scenes["dead"].stop()
      game_scenes["open"].start()


    #end
    clear_label = story_label("クリア")
    game_scenes["end"].add clear_label

    end_label = center_label("xキーで戻る",200)
    end_label.x += 45
    game_scenes["end"].add end_label
    game_scenes["end"].on 'bbuttondown', ->
      game_scenes["end"].stop()
      game_scenes["open"].start()


    #ゲームの下準備
    temp = game_scenes["open"]
    temp.first_start()


  game.start()
    
rand = (n) ->
  Math.floor(Math.random()*n)
