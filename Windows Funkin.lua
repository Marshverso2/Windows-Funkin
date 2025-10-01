versionW = 23.2
language = os.setlocale(nil, 'collate'):lower()
keys = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
toType = 'NAMEUNIT'
keyCache = ''
option = {
  select = 1,
  pag = {[1] = {}},
  pagView = 1,
  stop = false
}
blockColors = {'00ff99', '6666ff', 'ff3399', 'ff00ff', '00ffcc'}
repositories = {}
colunaDeTexto = 100

function onStartCountdown() if getDataFromSave('saiko', 'menu') then return Function_Stop end end

function text(tag, text, width, x, y)
  makeLuaText(tag, text, width, x, y)
  setObjectCamera(tag, 'camOther')
  addLuaText(tag)
end

function cmd(command, power)
  if power then
    io.popen([[start powershell -NoExit -Command "]]..command..[["]])
  else
    io.popen([[powershell -Command "Start-Process cmd -ArgumentList '/c color 9e && ]]..command..[[' -Verb RunAs"]])
  end

  playSound('confirmMenu', 0.9)
end

function addOptionCmd(tag, name, command, textToWrite, powershell)
  if #option.pag == 0 or #option.pag[#option.pag] >= 11 then
    table.insert(option.pag, {})
  end

  table.insert(option.pag[#option.pag], {tag, command, (textToWrite or 'Type'), (powershell or false)}) --ENTER THE LETTER OF THE STORAGE DRIVE
  text(tag..'Option', name, 750, 10, colunaDeTexto)
  setObjectOrder(tag..'Option', 30)
  setTextSize(tag..'Option', 30)
  setProperty(tag..'Option.alpha', 0.8)
  setProperty(tag..'Option.visible', true)

  if colunaDeTexto >= 600 then
    colunaDeTexto = 100
  else
    colunaDeTexto = colunaDeTexto + 50
  end
end

function changePage(page)
  option.pagView = option.pagView + page

  if option.pagView < 1 then
    option.pagView = #option.pag
  elseif option.pagView > #option.pag then
    option.pagView = 1
  end

  for p=1,#option.pag do
    for i, opt in ipairs(option.pag[p]) do
      setProperty(opt[1]..'Option.visible', false)
    end
  end

  for i, opt in ipairs(option.pag[option.pagView]) do
    setProperty(opt[1]..'Option.visible', true)
  end
end

function selectionOp()
  for i=1,#option.pag[option.pagView] do
    if option.select == i and not (getProperty(option.pag[option.pagView][i][1]..'Option.color') == -256) then
      setProperty(option.pag[option.pagView][i][1]..'Option.color', getColorFromHex('ffff00'))
      doTweenX(option.pag[option.pagView][i][1]..'OptionSX', option.pag[option.pagView][i][1]..'Option.scale', 1.1, 0.2, 'sineIn')
      setProperty(option.pag[option.pagView][i][1]..'Option.alpha', 1)
    else
      setProperty(option.pag[option.pagView][i][1]..'Option.color', getColorFromHex('ffffff'))
      doTweenX(option.pag[option.pagView][i][1]..'OptionSX', option.pag[option.pagView][i][1]..'Option.scale', 1, 0.2, 'sineIn')
      setProperty(option.pag[option.pagView][i][1]..'Option.alpha', 0.8)
    end
  end
end

function tobool(boolean)
  if boolean:lower() == 'true' then
    return true
  elseif boolean:lower() == 'false' then
    return false
  else
    return nil
  end
end

function onCreate()
  initSaveData('saiko', 'saiko')

  if not getDataFromSave('saiko', 'menu') then
    return Function_Stop
  end
  
  setProperty('camGame.visible', false)
  setProperty('camHUD.visible', false)

  text('versionW', 'v'..versionW, 100, 10, 2)
  setTextSize('versionW', 40)
  screenCenter('versionW', 'x')

  text('title', 'WINDOWS\nFUNKIN', 500, screenWidth, 50)
  setTextSize('title', 100)
  setTextAlignment('title', 'center')
  screenCenter('title', 'y')

  --options--
  text('seta1', '>', 70, 355, 50)
  setProperty('seta1.angle', -90)
  setTextSize('seta1', 50)

  addOptionCmd('cf', 'Check files', [[sfc /scannow && dism /online /cleanup-image /scanhealth && dism /online /cleanup-image /restorehealth]])
  addOptionCmd('cs', 'Check storage', [[chkdsk ]]..toType..[[: /f /r /x]], 'STORAGE LETTER (EX: C)')
  addOptionCmd('cr', 'Check ram (PC RESET)', [[mdsched.exe]])
  addOptionCmd('os', 'Optimize storage (HD EXCLUSIVE)', [[defrag ]]..toType..[[: /O]], 'STORAGE LETTER (EX: C)')
  addOptionCmd('cc', 'Clear cache', [[rmdir /s /q %TEMP% && rmdir /s /q C:\Windows\Temp && rmdir /s /q C:\Windows\Prefetch]])
  addOptionCmd('csc', 'Clear storage cache', [[cleanmgr]])
  addOptionCmd('ps', 'Performance settings', [[SystemPropertiesPerformance]])
  addOptionCmd('av', 'Anti-virus', [[mrt]])
  addOptionCmd('cd', 'Clear dns', [[ipconfig /flushdns]])

  addOptionCmd('twoao', 'Turn wifi off and on (Ethernet)', [[netsh interface set interface name="Ethernet" admin=disable & ECHO the router will turn on after the countdown & timeout /t TAPYNG /nobreak & netsh interface set interface name="Ethernet" admin=enable & completed]])
  addOptionCmd('srp', 'solve router problems (Ethernet+PC RESET)', [[netsh winsock reset & netsh int ip reset & shutdown /r /t 0]])
  addOptionCmd('smtc', 'send message to computers', [[MSG * "]]..toType..[["]], 'write your message')

  addOptionCmd('ewe', 'Enable Windows emulator (PC RESET)', [[Dism /online /Enable-Feature /FeatureName:"Containers-DisposableClientVM" -All && Y]])
  addOptionCmd('ia', 'Installed applications', [[explorer shell:AppsFolder]])
  addOptionCmd('ua', 'Update applications', [[winget upgrade --all]])
  addOptionCmd('sy', 'System settings', [[msconfig]])
  addOptionCmd('rc', 'Remote connection', [[mstsc]])
  addOptionCmd('id', 'Installed drivers', [[Driverquery -v && pause && exit /b]])
  addOptionCmd('pd', 'Power diagnosis', [[powercfg -energy && pause && exit /b]])
  addOptionCmd('m', 'Maintenance (PC RESET)', [[msdt.exe /id MaintenanceDiagnostic]])
  addOptionCmd('ids', 'System Information', [[systeminfo && pause && exit /b]])

  local getRepositoriesGit = io.popen('curl -s https://raw.githubusercontent.com/Marshverso2/Windows-Funkin-Repositories/refs/heads/main/Repositories.txt')
  local reporitoriesContent = getRepositoriesGit:read('*a')
  getRepositoriesGit:close()
  cacheGit = 1

  for content in reporitoriesContent:gmatch('[^\n]+') do
    local c1, c2, c3, c4 = content:match('^([^¨]+)¨([^¨]+)¨([^¨]+)¨(.*)')
    addOptionCmd('g'..cacheGit, c1..' (GITHUB)', c2, c3, tobool(c4))
    cacheGit = cacheGit + 1
  end

  addOptionCmd('voaris', 'View or add repository in script', [[start https://github.com/Marshverso2/Windows-Funkin-Repositories/blob/main/Repositories.txt]])


  text('seta2', '<', 70, 355, 630)
  setProperty('seta2.angle', -90)
  setTextSize('seta2', 50)
  ------------

  text('credits', 'Creator: Marshverso (YT)     Menu design: FacheFNF (DC) and Marshverso (YT)     Beta Testers: FandeFNF (YT) and Erislwlol(Twitter)', 0, screenWidth+50, screenHeight - 37)
  setTextSize('credits', 30)
  setTextAlignment('credits', 'left')
  doTweenX('creditsX', 'credits', -getProperty('credits.width'), 30, 'linear')

  makeLuaSprite('sBg')
  makeGraphic('sBg', screenWidth, screenHeight, '000000')
  setObjectCamera('sBg', 'other')
  setProperty('sBg.alpha', 0)
  addLuaSprite('sBg', true)

  text('description', '', screenWidth, 0, 200)
  setTextSize('description', 50)
  setProperty('description.alpha', 0)

  text('keyCacheTxt', '', screenWidth, 0, 0)
  setTextSize('keyCacheTxt', 50)
  screenCenter('keyCacheTxt', 'y')

  if getTextFromFile('music/breakfast-(pico).ogg') then
    playMusic('breakfast-(pico)', 0.5, true)
  else
    playMusic('breakfast', 0.5, true)
  end

  makeLuaSprite('bg')
  makeGraphic('bg', screenWidth, screenHeight, '003380')
  setObjectCamera('bg', 'camOther')
  addLuaSprite('bg', false)

  for i=1,80 do
    makeLuaSprite('block'..i, '', math.random(0, screenWidth-50), math.random(0, screenHeight-50))
    makeGraphic('block'..i, 40, 40, 'ffffff')
    setProperty('block'..i..'.color', getColorFromHex(blockColors[math.random(1,#blockColors)]))
    setObjectCamera('block'..i, 'camOther')
    setProperty('block'..i..'.angle', math.random(-180, 180))
    addLuaSprite('block'..i, false)

    setProperty('block'..i..'.velocity.x', math.random(-20, 20))
    setProperty('block'..i..'.acceleration.x', math.random(-30, 30))
    setProperty('block'..i..'.acceleration.y', math.random(-40, 40))
      
    setProperty('block'..i..'.alpha', math.random(0,1))
    doTweenAngle('block'..i..'An', 'block'..i, math.random(-180, 180), getRandomFloat(2,5), 'sineOut')
    doTweenAlpha('block'..i..'Al', 'block'..i, 0, getRandomFloat(2,15), 'backin')
  end

  makeLuaSprite('bg1')
  makeGraphic('bg1', screenWidth, 45, '4d4dff')
  setObjectCamera('bg1', 'camOther')
  addLuaSprite('bg1', false)

  makeLuaSprite('bg2', nil, 0, screenHeight - 45)
  makeGraphic('bg2', screenWidth, 45, '4d4dff')
  setObjectCamera('bg2', 'camOther')
  addLuaSprite('bg2', false)

  makeAnimatedLuaSprite('gfWindows', 'characters/GF_assets', 840, 450)
  addAnimationByPrefix('gfWindows', 'danceLeft', 'GF Dancing Beat0', 24, true)
  scaleObject('gfWindows', 0.35, 0.35, true)
  setObjectCamera('gfWindows', 'camOther')
  setProperty('gfWindows.antialiasing', false)
  addLuaSprite('gfWindows', false)

  runTimer('update', 1)
end

function onCreatePost()
  if not getDataFromSave('saiko', 'menu') then
    return Function_Stop
  end

  --animação de entrada
  doTweenX('titleX', 'title', screenWidth/1.9, 3, 'sineOut')
    
  for ii=1,#option.pag do
    for i=1,#option.pag[ii] do
      doTweenX(option.pag[ii][i][1]..'OptionX', option.pag[ii][i][1]..'Option', getProperty(option.pag[ii][i][1]..'Option.x'), 3, 'circOut')
      setProperty(option.pag[ii][i][1]..'Option.x', -getProperty(option.pag[ii][i][1]..'Option.width'))
    end
  end

  for i=1,2 do
    doTweenX('seta'..i, 'seta'..i, getProperty('seta'..i..'.x'), 3, 'circOut')
    setProperty('seta'..i..'.x', -getProperty('seta'..i..'.width'))
  end
  --

  selectionOp()
  changePage(0)

  setPropertyFromClass('flixel.FlxG', 'autoPause', false)
end

function onUpdate()
  if (getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SIX') or (getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') and getDataFromSave('saiko', 'menu'))) and not option.stop then
    if version >= '0.7.0' then
      setPropertyFromClass('flixel.FlxG', 'autoPause', getPropertyFromClass('backend.ClientPrefs', 'data.autoPause'))
    end

    setDataFromSave('saiko', 'menu', not getDataFromSave('saiko', 'menu'))
    restartSong(false)
    close(false)
  end

  if not option.stop and getDataFromSave('saiko', 'menu') then
    if not option.stop and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') then
      restartSong(true)
    end

    --select--
    if keyJustPressed('up') or keyJustPressed('down') then
      option.select = (keyJustPressed('up') and option.select - 1 or option.select + 1)

      if option.select < 1 or option.select > #option.pag[option.pagView] then
        changePage(((option.select < 1) and -1 or 1))
        option.select = (keyJustPressed('up') and #option.pag[option.pagView] or 1)
      end

      playSound('scrollMenu', 0.7)
      selectionOp()
    end
    ---------

    --confirm option
    if keyJustPressed('accept') then
      if option.pag[option.pagView][option.select][2]:find(toType) and not option.stop then
        option.stop = true
        setTextString('description', option.pag[option.pagView][option.select][3])
        doTweenAlpha('descriptionAl', 'description', 1, 0.5, 'linear')
        doTweenAlpha('sBgAl', 'sBg', 0.7, 0.5, 'linear')
      elseif not option.stop then
        cmd(option.pag[option.pagView][option.select][2], option.pag[option.pagView][option.select][4])
      end
    end
  end

  --NAME UNIT
  if option.stop and option.pag[option.pagView][option.select][2]:find(toType) then
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ANY') then
      for i, key in ipairs(keys) do
        if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..key:upper()) then
          keyCache = keyCache..(getPropertyFromClass('flixel.FlxG', 'keys.pressed.SHIFT') and key:upper() or key)
          break
        end
      end

      if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.BACKSPACE') then
        keyCache = keyCache:sub(1, -2)
      end

      if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then
        keyCache = keyCache..' '
      end

      if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') and #keyCache >= 1 then
        cmd(option.tag[option.select][3]:gsub(toType, keyCache))
        option.stop = false
        setProperty('description.alpha', 0)
        setProperty('sBg.alpha', 0)
        keyCache = ''
        setTextString('keyCacheTxt', '')
      end

      if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') then
        option.stop = false
        doTweenAlpha('descriptionAl', 'description', 0, 0.5, 'linear')
        doTweenAlpha('sBgAl', 'sBg', 0, 0.5, 'linear')
        keyCache = ''
        setTextString('keyCacheTxt', '')
      end

      setTextString('keyCacheTxt', keyCache)
    end
  end
end

function onTweenCompleted(tag)
  if tag == 'titleX' then
    if getProperty('title.x') == screenWidth/1.9 then
      doTweenX('titleX', 'title', screenWidth/1.7, 2.5, 'sineInOut')
    else
      doTweenX('titleX', 'title', screenWidth/1.9, 2.5, 'sineInOut')
    end
  end

  --blocks
  for i=1,80 do
    if tag == 'block'..i..'Al' then
      setProperty('block'..i..'.x', math.random(0, screenWidth-150))
      setProperty('block'..i..'.y', math.random(50, screenHeight-150))

      setProperty('block'..i..'.color', getColorFromHex(blockColors[math.random(1,#blockColors)]))

      for _,exis in pairs({'x', 'y'}) do
        setProperty('block'..i..'.acceleration.'..exis, math.random(-20, 20))
        setProperty('block'..i..'.velocity.'..exis, math.random(-20, 20))
      end

      doTweenAngle('block'..i..'An', 'block'..i, math.random(-180, 180), getRandomFloat(2,5), 'sineOut')
      doTweenAlpha('block'..i..'Al1', 'block'..i, 1, getRandomFloat(2,8), 'backIn')
    end

    if tag == 'block'..i..'Al1' then
      doTweenAlpha('block'..i..'Al', 'block'..i, 0, getRandomFloat(2,8), 'backIn')
    end
  end

  if tag == 'creditsX' then
    setProperty('credits.x', screenWidth+50)
    doTweenX('creditsX', 'credits', -getProperty('credits.width'), 60, 'linear')
  end  
end

function onTimerCompleted(tag, loops, loopsLeft)
  if tag == 'update' then
    --Obter o código no GitHub
    versionWindowsFunkin = io.popen('curl -s https://raw.githubusercontent.com/Marshverso2/Windows-Funkin/refs/heads/main/Windows%20Funkin.lua')
    scriptContent = versionWindowsFunkin:read('*a')
    versionWindowsFunkin:close()
    versionOnline = scriptContent:match('versionW = (%d+)')

    --se a versão é desatualizada ou se você não tem ele, ele vai baixar
    if tonumber(versionW) < tonumber(versionOnline) then
      webScript = io.popen('curl -s https://raw.githubusercontent.com/Marshverso2/Windows-Funkin/refs/heads/main/Windows%20Funkin.lua')
      saveFile(scriptName, webScript:read('*a'), true)
      webScript:close()
      runTimer('rwf', 1)
    end
  end

  if tag == 'rwf' then
    restartSong(false)
  end
end

