versionW = 27.0
credits = {'Creator: Marshverso (YT)', 'Beta Testers: FandeFNF (YT) and Erislwlol(Twitter)'}
toType = 'NAMEUNIT'
keyCache = ''
option = {
  select = 1,
  pag = {[1] = {}},
  pagView = 1,
  stop = false
}
blockMax = 100
blockColors = {'00ff99', '6666ff', 'ff3399', 'ff00ff', 'FFFF00'}
colunaDeTexto = 350
cache = ''
keys = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
system = {
  ['linux'] = 'lnx',
  ['unknown'] = 'lnx',
  ['mac'] = 'mac',
  ['windows'] = 'win'
}
dev = false
luaDebugMode = true

function onStartCountdown() if getDataFromSave('assistent funkin girl', 'menu') then return Function_Stop end end

function updateScript()
  github = io.popen(((buildTarget == 'linux' or buildTarget == 'mac') and 'curl -fsSL' or 'curl -s')..' https://raw.githubusercontent.com/Marshverso2/Windows-Funkin/refs/heads/main/Windows%20Funkin.lua')
  scriptContent = github:read('*a')
  online = (scriptContent and true or false)

  if online and scriptContent ~= nil then
    versionOnline = scriptContent:match('versionW = (%d+)')

    if tonumber(versionW) < tonumber(versionOnline) then
      saveFile(scriptName, scriptContent, true)
      runTimer('rwf', 1)
    end
  end

  versionW = versionW..' ('..(online and 'ONLINE' or 'OFFLINE')..')'

  github:close()
end

function options()
  addOptionCmd('cf', 'Check files', {
    [[|lnx| sudo fsck -Af -M]],
    [[|mac| sudo diskutil verifyVolume /]],
    [[|win| sfc /scannow]]..(online and [[ && dism /online /cleanup-image /scanhealth && dism /online /cleanup-image /restorehealth]] or '')
  })


  addOptionCmd('cs', 'Check storage', {
    [[|lnx| sudo fsck ]]..toType,
    [[|mac| sudo diskutil verifyVolume ]]..toType,
    [[|win| chkdsk ]]..toType..[[: /f /r /x]]
  }, 'STORAGE '..(
    buildTarget == 'linux' and 'STORAGE (EX: /dev/sda1)' or
    buildTarget == 'mac'   and 'STORAGE (EX: disk0s1)' or
    'STORAGE LETTER (EX: C)'
  ))


  addOptionCmd('cr', 'Check ram', {
    [[|lnx| sudo memtester 1024M 1]],
    [[|mac| echo "Apple Diagnostics: desligue o Mac e ligue segurando D"]],
    [[|win| mdsched.exe]]
  })


  addOptionCmd('os', 'Optimize storage (HD EXCLUSIVE)', {
    [[|lnx| sudo e4fsck -f ]],
    [[|mac| sudo diskutil repairVolume ]]..toType,
    [[|win| defrag ]]..toType..[[: /O]]
  }, 'STORAGE '..(
    buildTarget == 'linux' and '(EX: /dev/sda1)' or
    buildTarget == 'mac'   and '(EX: disk0s1)' or
    'LETTER (EX: C)'
  ))


  addOptionCmd('cc', 'Clear cache', {
    [[|lnx| sudo apt clean && sudo apt autoremove -y && sync; echo 3 | sudo tee /proc/sys/vm/drop_caches]],
    [[|mac| sudo rm -rf ~/Library/Caches/* /Library/Caches/* && sudo purge]],
    [[|win| rmdir /s /q %TEMP% && rmdir /s /q C:\Windows\Temp && rmdir /s /q C:\Windows\Prefetch && cleanmgr]]
  })


  addOptionCmd('ps', 'Performance settings', {
    [[|lnx| gnome-control-center]],
    [[|mac| open /System/Library/PreferencePanes/EnergySaver.prefPane]],
    [[|win| SystemPropertiesPerformance]]
  })


  addOptionCmd('av', 'Anti-virus', {
    [[|lnx| clamscan -r /]],
    [[|mac| clamscan -r /]],
    [[|win| mrt]]
  })


  addOptionCmd('cd', 'Clear dns', {
    [[|lnx| sudo systemd-resolve --flush-caches]],
    [[|mac| sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder]],
    [[|win| ipconfig /flushdns]]
  })


  addOptionCmd('twoao', 'Turn wifi off and on (Ethernet)', {
    [[|lnx| sudo nmcli networking off && sleep 10 && sudo nmcli networking on]],
    [[|mac| networksetup -setnetworkserviceenabled Ethernet off && sleep 10 && networksetup -setnetworkserviceenabled Ethernet on]],
    [[|win| netsh interface set interface name="Ethernet" admin=disable & timeout /t 10 & netsh interface set interface name="Ethernet" admin=enable]]
  })


  addOptionCmd('srp', 'Solve router problems (Ethernet)', {
    [[|lnx| sudo systemctl restart NetworkManager]],
    [[|mac| sudo ifconfig en0 down && sudo ifconfig en0 up]],
    [[|win| netsh winsock reset & netsh int ip reset & shutdown /r /t 0]]
  })


  if online then
    addOptionCmd('smtc', 'Send message to computers', {
      [[|lnx| wall "]]..toType..[["]],
      [[|mac| osascript -e 'display alert "Message" message "]]..toType..[["']],
      [[|win| MSG * "]]..toType..[["]]
    }, 'write your message')
  end


  addOptionCmd('ia', 'Installed applications', {
    [[|lnx| dpkg -l || flatpak list || snap list]],
    [[|mac| ls /Applications]],
    [[|win| explorer shell:AppsFolder]]
  })


  if online then
    addOptionCmd('ai', 'Application name/id', {
      [[|lnx| apt list --installed]],
      [[|mac| brew list]],
      [[|win| winget list]]
    }, false, true)

    addOptionCmd('rp', 'Force uninstall application', {
      [[|lnx| sudo apt purge ]]..toType,
      [[|mac| brew uninstall ]]..toType,
      [[|win| winget uninstall ]]..toType
    }, [[Write the application ]]..(
      buildTarget == 'linux' and 'name' or
      buildTarget == 'mac'   and 'name' or
      'ID'
    ), true)

    addOptionCmd('ua', 'Update applications', {
      [[|lnx| sudo apt update && sudo apt upgrade -y]],
      [[|mac| brew update && brew upgrade]],
      [[|win| winget upgrade --all]]
    })
  end


  addOptionCmd('sy', 'System settings', {
    [[|lnx| gnome-control-center]],
    [[|mac| open /System/Library/PreferencePanes]],
    [[|win| msconfig]]
  })


  if online then
    addOptionCmd('rc', 'Remote connection', {
      [[|lnx| remmina]],
      [[|mac| open vnc://]],
      [[|win| mstsc]]
    })

    addOptionCmd('id', 'Installed drivers', {
      [[|lnx| lspci -k && lsusb]],
      [[|mac| system_profiler SPHardwareDataType SPUSBDataType]],
      [[|win| Driverquery -v && pause && exit /b]]
    })
  end


  addOptionCmd('pd', 'Power diagnosis', {
    [[|lnx| sudo powertop]],
    [[|mac| pmset -g batt]],
    [[|win| powercfg -energy && pause && exit /b]]
  })


  addOptionCmd('eb', 'Enter bios', {
    [[|lnx| sudo systemctl reboot --firmware-setup]],
    [[|mac| sudo nvram -d boot-args && sudo shutdown -r now]],
    [[|win| shutdown /r /fw /t 0]]
  })


  addOptionCmd('ids', 'System information', {
    [[|lnx| neofetch || inxi -Fxz]],
    [[|mac| system_profiler SPSoftwareDataType SPHardwareDataType]],
    [[|win| systeminfo && pause && exit /b]]
  })


  addOptionCmd('m', 'Maintenance (PC RESET)', {
    [[|lnx| sudo apt autoremove -y && sudo apt clean]],
    [[|mac| softwareupdate -i -a]],
    [[|win| msdt.exe /id MaintenanceDiagnostic]]
  })


  if online and buildTarget:find('windows') then
    local getRepositoriesGit = io.popen('start /B curl -s https://raw.githubusercontent.com/Marshverso2/Windows-Funkin-Repositories/refs/heads/main/Repositories.txt')
    local reporitoriesContent = getRepositoriesGit:read('*a')
    getRepositoriesGit:close()
    cacheGit = 1

    for content in reporitoriesContent:gmatch('[^\n]+') do
      local c1, c2, c3, c4 = content:match('^([^¨]+)¨([^¨]+)¨([^¨]+)¨(.*)')
      addOptionCmd('g'..cacheGit, c1..' (GITHUB)', c2, c3, tobool(c4))
      cacheGit = cacheGit + 1
    end

    addOptionCmd('voaris', 'View or add repository in script', {
      [[|win| start /B https://github.com/Marshverso2/Windows-Funkin-Repositories/blob/main/Repositories.txt]],
      [[|lnx| xdg-open https://github.com/Marshverso2/Windows-Funkin-Repositories/blob/main/Repositories.txt]],
      [[|mac| open https://github.com/Marshverso2/Windows-Funkin-Repositories/blob/main/Repositories.txt]]
    })
  end
end

function text(tag, text, width, x, y)
  makeLuaText(tag, text, width, x, y)
  setObjectCamera(tag, 'camOther')
  addLuaText(tag)
end

function cmd(command, power, noSound)
  if buildTarget:find('windows') then
    if power then
      io.popen([[start powershell -NoExit -Command "]]..command..[["]])
    else
      io.popen([[powershell -Command "Start-Process cmd -ArgumentList '/c color 9e && ]]..command..[[' -Verb RunAs"]])
    end
  elseif buildTarget == 'linux' or buildTarget == 'unknown' then
    io.popen(command)
  elseif buildTarget == 'mac' then
    io.popen([[osascript -e 'do shell script "]]..command..[[" with administrator privileges']])
  end

  if not noSound then
    playSound('confirmMenu', 0.9)
  end
end

function addOptionCmd(tag, name, command, textToWrite, powershell)
  if #option.pag == 0 or #option.pag[#option.pag] >= 6 then
    table.insert(option.pag, {})
  end

  if type(command) == 'table' then
    for i, c in ipairs(command) do

      if c:find('|'..system[buildTarget]..'|') then
        command = c:gsub('|'..system[buildTarget]..'|%s*', '')
        break
      end

    end
  else
    if command:find('|'..system[buildTarget]..'|') then
      command = command:gsub('|'..system[buildTarget]..'|%s*', '')
    end
  end

  table.insert(option.pag[#option.pag], {
    tag,
    command,
    (textToWrite or 'Type'),
    (powershell or false)
  })

  text(tag..'Option', name..((command:find('shutdown /r') or command:find('sudo reboot')) and ' (PC RESET)' or ''), screenWidth, 0, colunaDeTexto)
  setObjectOrder(tag..'Option', 30)
  setTextSize(tag..'Option', 30)
  setProperty(tag..'Option.alpha', 0.8)
  setProperty(tag..'Option.visible', true)

  if colunaDeTexto >= 600 then
    colunaDeTexto = 350
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

function select()
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
  initSaveData('assistent funkin girl', 'assistent funkin girl')

  if not getDataFromSave('assistent funkin girl', 'menu') then
    return Function_Stop
  end

  updateScript()

  setProperty('camGame.visible', false)
  setProperty('camHUD.visible', false)

  text('versionW', 'v'..versionW, screenWidth, 0, 2)
  setTextSize('versionW', 40)
  screenCenter('versionW', 'x')
  setProperty('versionW.alpha', 0)
  doTweenAlpha('versionWAl', 'versionW', 1, 3, 'backInOut')

  text('title', 'ASSISTANT\nFUNKIN\nGIRL', screenWidth, 800, 75)
  setTextSize('title', 80)
  setTextAlignment('title', 'center')

  for i,c in pairs(credits) do
    cache = cache..c..(i == #credits and '' or '     ')
  end

  text('credits', cache, 0, screenWidth+50, screenHeight - 37)
  setTextSize('credits', 30)
  setTextAlignment('credits', 'left')
  doTweenX('creditsX', 'credits', getProperty('credits.width'), 0.1, 'linear')

  --options--
  text('seta1', '>', screenWidth, 0, 310)
  setProperty('seta1.angle', -90)
  setTextSize('seta1', 50)

  options()

  text('seta2', '<', screenWidth, 0, 630)
  setProperty('seta2.angle', -90)
  setTextSize('seta2', 50)
  ------------

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

  --BG
  if not dev then
    makeLuaSprite('bg')
    makeGraphic('bg', screenWidth, screenHeight, '003380')
    setObjectCamera('bg', 'camOther')
    addLuaSprite('bg', false)
  end

  if lowQuality then
    blockMax = blockMax/4
  end

  for i=1,blockMax do
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

  if not lowQuality then
    for i=1,2 do
      makeAnimatedLuaSprite('gfWindows'..i, 'characters/GF_assets', 1070, -288)
      addAnimationByPrefix('gfWindows'..i, 'danceLeft', 'GF Dancing Beat0', 24, true)
      scaleObject('gfWindows'..i, 1.5, 1.5, true)
      setObjectCamera('gfWindows'..i, 'camOther')
      setProperty('gfWindows'..i..'.antialiasing', true)
      addLuaSprite('gfWindows'..i, false)

      if i == 2 then
        setProperty('gfWindows'..i..'.x', screenWidth - getProperty('gfWindows'..i..'.width') - getProperty('gfWindows1.x'))
      end
    end
  end

  if not dev then
    makeLuaSprite('bg1')
    makeGraphic('bg1', screenWidth, 45, '4d4dff')
    setObjectCamera('bg1', 'camOther')
    addLuaSprite('bg1', false)

    makeLuaSprite('bg2', nil, 0, screenHeight - 45)
    makeGraphic('bg2', screenWidth, 45, '4d4dff')
    setObjectCamera('bg2', 'camOther')
    addLuaSprite('bg2', false)
  end

  runTimer('update', 1)
end



function onCreatePost()
  if not getDataFromSave('assistent funkin girl', 'menu') then
    return Function_Stop
  end

  --animação de entrada
  doTweenX('titleX', 'title', -10, 3, 'sineOut')
    
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

  select()
  changePage(0)

  setPropertyFromClass('flixel.FlxG', 'autoPause', false)
end



function onUpdate()
  --entrar no 
  if (getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SIX') or (getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') and getDataFromSave('assistent funkin girl', 'menu'))) and not option.stop then
    setDataFromSave('assistent funkin girl', 'menu', not getDataFromSave('assistent funkin girl', 'menu'))
    restartSong(false)
    close(false)
  end

  if not option.stop and getDataFromSave('assistent funkin girl', 'menu') then

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
      select()
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
      if getPropertyFromClass('flixel.FlxG', 'keys.pressed.CONTROL') and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.V') then
        cache = io.popen([[powershell -command "Get-Clipboard"]])
        cache1 = cache:read()
        cache:close()
        keyCache = keyCache..cache1
      else
        for i, key in ipairs(keys) do
          if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.'..key:upper()) then
            keyCache = keyCache..(getPropertyFromClass('flixel.FlxG', 'keys.pressed.SHIFT') and key:upper() or key)
            break
          end
        end
      end

      if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.BACKSPACE') then
        keyCache = keyCache:sub(1, -2)
      end

      if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then
        keyCache = keyCache..' '
      end

      if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') and #keyCache >= 1 then
        cmd(option.pag[option.pagView][option.select][2]:gsub(toType, keyCache))
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
    if getProperty('title.x') == -10 then
      doTweenX('titleX', 'title', 10, 1, 'sineInOut')
    else
      doTweenX('titleX', 'title', -10, 1, 'sineInOut')
    end
  end

  --blocks
  for i=1,blockMax do
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
    doTweenX('creditsX', 'credits', -getProperty('credits.width'), 10, 'linear')
  end  
end





function onTimerCompleted(tag, loops, loopsLeft)
  if tag == 'rwf' then
    restartSong(false)
  end
end
