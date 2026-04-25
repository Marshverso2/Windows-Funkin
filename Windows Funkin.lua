versionW = 29.0
repository = {
  directory = {
    storage = 'mods',
    online = 'https://raw.githubusercontent.com/Marshverso2/Windows-Funkin/main/files/'
  },
  files = {},
}

credits = {'Creator: Marshverso (YT)', 'Beta Testers: FandeFNF (YT) and Erislwlol(Twitter)', 'Donor: Xnml (Twitter)'}

option = {
  select = 1,
  pag = {[1] = {}},
  pagView = 1,
  toType = 'WriteSomething',
  stop = false
}

keys = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'}
keyCache = ''
colunaDeTexto = 350

blockMax = 100
blockColors = {'00ff99', '6666ff', 'ff3399', 'ff00ff', 'FFFF00'}

system = {
  ['linux'] = 'lnx',
  ['unknown'] = 'lnx',
  ['mac'] = 'mac',
  ['windows'] = 'win'
}

AFG = [[I'm sad it's over, but I know it's for my own good :).]]

cache = ''
test = 0

function onStartCountdown() if getDataFromSave('assistent funkin girl', 'menu') then return Function_Stop end end

function updateScript()
  github = io.popen(((buildTarget == 'linux' or buildTarget == 'mac') and 'curl -fsSL' or 'curl -s')..' https://raw.githubusercontent.com/Marshverso2/Windows-Funkin/refs/heads/main/Windows%20Funkin.lua')
  scriptContent = github:read('*a')
  online = ((#scriptContent >= 1) and true or false)

  if online then

    versionOnline = scriptContent:match('versionW = (%d+)')

    for _,file in ipairs(repository.files) do

      if not getTextFromFile('mods/'..file) then
        local cacheFile = string.format('echo DOWNLOAD '..file..' && curl -L "%s" -o "%s"', repository.directory.online.file, 'mods/'..file)
        local downloadFile = io.popen(cacheFile)
        downloadFile:close()
      end

    end

    if tonumber(versionW) < tonumber(versionOnline) then

      saveFile(scriptName, scriptContent, true)
      runTimer('rwf', 1)

    end

  end

  versionW = versionW..' ('..(online and 'ONLINE' or 'OFFLINE')..')'

  github:close()
end

function options()
  addOption('cf', 'Check files', {
    [[|lnx| sudo fsck -Af -M]],
    [[|mac| sudo diskutil verifyVolume /]],
    [[|win| sfc /scannow]]..(online and [[ && dism /online /cleanup-image /scanhealth && dism /online /cleanup-image /restorehealth]] or '')
  })


  addOption('cs', 'Check storage', {
    [[|lnx| sudo fsck ]]..option.toType,
    [[|mac| sudo diskutil verifyVolume ]]..option.toType,
    [[|win| chkdsk ]]..option.toType..[[: /f /r /x]]
  }, 'STORAGE LETTER'..(
    buildTarget == 'linux' and 'S (EX: /dev/sda1)' or
    buildTarget == 'mac' and 'S (EX: disk0s1)' or
    ' (EX: C)'
  ))


  addOption('os', 'Optimize storage', {
    [[|lnx| sudo e4fsck -f ]],
    [[|mac| sudo diskutil repairVolume ]]..option.toType,
    [[|win| defrag ]]..option.toType..[[: /O]]
  }, '[EXCLUSIVO PARA HD]\n\nSTORAGE LETTER'..(
    buildTarget == 'linux' and 'S (EX: /dev/sda1)' or
    buildTarget == 'mac'   and 'S (EX: disk0s1)' or
    ' (EX: C)'
  ))

  addOption('cc', 'Clear cache', {
    [[|lnx| sudo apt clean && sudo apt autoremove -y && sync; echo 3 | sudo tee /proc/sys/vm/drop_caches]],
    [[|mac| sudo rm -rf ~/Library/Caches/* /Library/Caches/* && sudo purge]],
    [[|win| rmdir /s /q %TEMP% && rmdir /s /q C:\Windows\Temp && rmdir /s /q C:\Windows\Prefetch && cleanmgr]]
  })


  addOption('cr', 'Check ram', {
    [[|lnx| sudo memtester 1024M 1]],
    [[|mac| echo "Apple Diagnostics: desligue o Mac e ligue segurando D"]],
    [[|win| mdsched.exe]]
  })


  addOption('ps', 'Performance settings', {
    [[|lnx| gnome-control-center]],
    [[|mac| open /System/Library/PreferencePanes/EnergySaver.prefPane]],
    [[|win| SystemPropertiesPerformance]]
  })

  addOption('cd', 'Clear dns', {
    [[|lnx| sudo systemd-resolve --flush-caches]],
    [[|mac| sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder]],
    [[|win| ipconfig /flushdns]]
  })


  addOption('twoao', 'Turn wifi off and on', {
    [[|lnx| sudo nmcli networking off && sleep 10 && sudo nmcli networking on]],
    [[|mac| networksetup -setnetworkserviceenabled Ethernet off && sleep 10 && networksetup -setnetworkserviceenabled Ethernet on]],
    [[|win| netsh interface set interface name="Ethernet" admin=disable & timeout /t 10 & netsh interface set interface name="Ethernet" admin=enable]]
  }, [[Requires a wired connection to the router (Ethernet).]])


  addOption('srp', 'Solve router problems', {
    [[|lnx| sudo systemctl restart NetworkManager]],
    [[|mac| sudo ifconfig en0 down && sudo ifconfig en0 up]],
    [[|win| netsh winsock reset & netsh int ip reset & shutdown /r /t 0]]
  }, [[Requires a wired connection to the router (Ethernet).]])

  addOption('ia', 'Installed applications', {
    [[|lnx| dpkg -l || flatpak list || snap list]],
    [[|mac| ls /Applications]],
    [[|win| explorer shell:AppsFolder]]
  })


  if online then

    addOption('ai', 'Application name/id', {
      [[|lnx| apt list --installed]],
      [[|mac| brew list]],
      [[|win| winget list]]
    }, nil, true)


    addOption('rp', 'Force uninstall application', {
      [[|lnx| sudo apt purge ]]..option.toType,
      [[|mac| brew uninstall ]]..option.toType,
      [[|win| winget uninstall ]]..option.toType
    }, [[Open the option "Application name/id" and then Write the application ]]..(
      buildTarget == 'linux' and 'name' or
      buildTarget == 'mac'   and 'name' or
      'ID'
    ), true)


    addOption('ua', 'Update applications', {
      [[|lnx| sudo apt update && sudo apt upgrade -y]],
      [[|mac| brew update && brew upgrade]],
      [[|win| winget upgrade --all]]
    })

  end


  addOption('sy', 'System settings', {
    [[|lnx| gnome-control-center]],
    [[|mac| open /System/Library/PreferencePanes]],
    [[|win| msconfig]]
  })

  addOption('dh', 'Disable hibernation', {
    [[|lnx| sudo systemctl mask hibernate.target suspend.target]],
    [[|mac| sudo pmset -a hibernatemode 0]],
    [[|win| powercfg -h off]]
  })


  if buildTarget:find('windows') then
    addOption('dwu', 'Disable windows update', {
      [[|win| Stop-Service -Name wuauserv -Force -ErrorAction Stop && Set-Service -Name wuauserv -StartupType Disabled]]}, nil, true)
  end

  addOption('pd', 'Power diagnosis', {
    [[|lnx| sudo powertop]],
    [[|mac| pmset -g batt]],
    [[|win| powercfg -energy && pause && exit /b]]
  })


  addOption('eb', 'Enter bios', {
    [[|lnx| sudo systemctl reboot --firmware-setup]],
    [[|mac| sudo nvram -d boot-args && sudo shutdown -r now]],
    [[|win| shutdown /r /fw /t 0]]
  })


  addOption('ids', 'System information', {
    [[|lnx| neofetch || inxi -Fxz]],
    [[|mac| system_profiler SPSoftwareDataType SPHardwareDataType]],
    [[|win| systeminfo && pause && exit /b]]
  })


  addOption('av', 'Anti-virus', {
    [[|lnx| clamscan -r /]],
    [[|mac| clamscan -r /]],
    [[|win| mrt]]
  })


  addOption('m', 'Maintenance', {
    [[|lnx| sudo apt autoremove -y && sudo apt clean]],
    [[|mac| softwareupdate -i -a]],
    [[|win| msdt.exe /id MaintenanceDiagnostic]]
  }, 'This option requires you to restart your PC.')


  if buildTarget:find('windows') then

    if online then

      local getRepositoriesGit = io.popen('start /B curl -s https://raw.githubusercontent.com/Marshverso2/Windows-Funkin-Repositories/refs/heads/main/Repositories.txt')
      local reporitoriesContent = getRepositoriesGit:read('*a')
      getRepositoriesGit:close()
      cacheGit = 1

      for content in reporitoriesContent:gmatch('[^\n]+') do
        local c1, c2, c3, c4, c5 = content:match('^([^¨]+)¨([^¨]+)¨([^¨]+)¨([^¨]+)¨([^¨]*)')
        local c1 = c1..' (GITHUB)'
        local c5 = c5 or '???'
        table.insert(credits, c1..': '..c5)
        addOption('g'..cacheGit, c1, c2, 'This code was created by someone else.If you have any problems, please notify the creator.', tobool(c4))
        cacheGit = cacheGit + 1
      end

    end
  end

  if online then
    addOption('voaris', 'view AFG directory', {
      [[|win| start https://github.com/Marshverso2/Windows-Funkin-Repositories/tree/main]],
      [[|lnx| xdg-open https://github.com/Marshverso2/Windows-Funkin-Repositories/tree/main]],
      [[|mac| open https://github.com/Marshverso2/Windows-Funkin-Repositories/tree/main]]
    }, 'If you want to add a directory, contact the creator Marshverso.', true)

    addOption('dttp', 'Donate to the project', {
    [[|win| start https://youtu.be/dQw4w9WgXcQ?si=iTy0Ua-00NEWUgLd]],
    [[|lnx| xdg-open https://youtu.be/dQw4w9WgXcQ?si=iTy0Ua-00NEWUgLd]],
    [[|mac| open https://youtu.be/dQw4w9WgXcQ?si=iTy0Ua-00NEWUgLd]]
    }, 'ATTENTION\n\n80% of all donated money will go to charities.\n\nThe project has never survived on money alone, but rather on the community that supports it to this day.\n\nIf they made you pay for this, know that you were scammed.', true)
  end
end

function text(tag, text, width, x, y) makeLuaText(tag, text, width, x, y) setObjectCamera(tag, 'camOther') addLuaText(tag) end

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

function addOption(tag, name, command, information, powershell)
  if #option.pag == 0 or #option.pag[#option.pag] >= 6 then table.insert(option.pag, {}) end

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

  --AVISOS AUTOMATICOS--
  ---------------------------
  if command:find('shutdown /r') or command:find('reboot') then
    information = (information or '')..'\nFor the code to work, he needs to restart his computer.'
  end

  if not command:find(option.toType) and information then information = information..'\n\nPress Enter to continue.' end
  ---------------------------

  table.insert(option.pag[#option.pag], {
    tag,
    command,
    information,
    (powershell or false)
  })

  text(tag..'Option', name, screenWidth, 0, colunaDeTexto)
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

    cancelTimer(option.pag[option.pagView][i][1]..'OptionSX')

    setProperty(option.pag[option.pagView][i][1]..'Option.color', getColorFromHex('ffffff'))
    doTweenX(option.pag[option.pagView][i][1]..'OptionSX', option.pag[option.pagView][i][1]..'Option.scale', 1, 0.1, 'sineOut')
    setProperty(option.pag[option.pagView][i][1]..'Option.alpha', 0.8)

    if option.select == i and not (getProperty(option.pag[option.pagView][i][1]..'Option.color') == -256) then
      setProperty(option.pag[option.pagView][i][1]..'Option.color', getColorFromHex('ffff00'))
      doTweenX(option.pag[option.pagView][i][1]..'OptionSX', option.pag[option.pagView][i][1]..'Option.scale', 1.1, 0.1, 'sineOut')
      setProperty(option.pag[option.pagView][i][1]..'Option.alpha', 1)
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

  --options--
  text('seta1', '>', screenWidth, 0, 310)
  setProperty('seta1.angle', -90)
  setTextSize('seta1', 50)

  options()

  text('seta2', '<', screenWidth, 0, 630)
  setProperty('seta2.angle', -90)
  setTextSize('seta2', 50)
  ------------

  for i,c in pairs(credits) do
    cache = cache..c..(i == #credits and '' or '     ')
  end

  text('credits', cache, 0, screenWidth+50, screenHeight - 37)
  setTextSize('credits', 30)
  setTextAlignment('credits', 'left')
  doTweenX('creditsX', 'credits', getProperty('credits.width'), 0.1, 'linear')

  makeLuaSprite('sBg')
  makeGraphic('sBg', screenWidth, screenHeight, '000000')
  setObjectCamera('sBg', 'other')
  setProperty('sBg.alpha', 0)
  addLuaSprite('sBg', true)

  text('description', '', screenWidth-50, 0, 200)
  setTextSize('description', 50)
  setProperty('description.alpha', 0)
  screenCenter('description', 'x')

  text('keyCacheTxt', '', screenWidth, 0, 0)
  setTextSize('keyCacheTxt', 50)
  screenCenter('keyCacheTxt', 'y')
  setProperty('keyCacheTxt.color', getColorFromHex('FFFF00'))

  if getTextFromFile('music/breakfast-(pico).ogg') then
    playMusic('breakfast-(pico)', 0.5, true)
  else
    playMusic('breakfast', 0.5, true)
  end

  --BG
  if not luaDebugMode then

    makeLuaSprite('bg')
    makeGraphic('bg', screenWidth, screenHeight, '003380')
    setObjectCamera('bg', 'camOther')
    addLuaSprite('bg', false)

  end

  if lowQuality then blockMax = blockMax/4 end

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

      if i == 2 then setProperty('gfWindows'..i..'.x', screenWidth - getProperty('gfWindows'..i..'.width') - getProperty('gfWindows1.x')) end
    end

  end

  if not luaDebugMode then

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
  if not getDataFromSave('assistent funkin girl', 'menu') then return Function_Stop end

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



function onUpdate(elapsed)
  --entrar no AFG--
  if (getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SIX') or (getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ESCAPE') and getDataFromSave('assistent funkin girl', 'menu'))) and not option.stop then

    setDataFromSave('assistent funkin girl', 'menu', not getDataFromSave('assistent funkin girl', 'menu'))
    restartSong(false)
    close(false)

  end

  if not option.stop and getDataFromSave('assistent funkin girl', 'menu') then

    --Falas da garota
    if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SHIFT') and getTextString('versionW') ~= 'Girl: '..AFG then
      setTextString('versionW', 'Girl: '..AFG)
      playSound('GF_'..getRandomInt(1,4), 1)
    end


    --RESETAR SCRIPT
    if not option.stop and getPropertyFromClass('flixel.FlxG', 'keys.justPressed.R') then restartSong(true) end

    --SELECIONAMENTO--
    for _,control in pairs({{'W', 'S'}, {'UP', 'DOWN'}}) do

      if getPropertyFromClass('flixel.FlxG', 'keys.pressed.'..control[1]) or getPropertyFromClass('flixel.FlxG', 'keys.pressed.'..control[2]) then

        if test == 0 or test >= 30 and test % 20 == 0 then
          option.select = (getPropertyFromClass('flixel.FlxG', 'keys.pressed.'..control[1]) and option.select - 1 or option.select + 1)
          playSound('scrollMenu', 0.6)
        end

        if option.select < 1 or option.select > #option.pag[option.pagView] then
          changePage(((option.select < 1) and -1 or 1))
          option.select = (getPropertyFromClass('flixel.FlxG', 'keys.pressed.'..control[1]) and #option.pag[option.pagView] or 1)
        end

        select()

        test = test + 1

      end

      if test >= 1 and (getPropertyFromClass('flixel.FlxG', 'keys.justReleased.'..control[1]) or getPropertyFromClass('flixel.FlxG', 'keys.justReleased.'..control[2])) then
        test = 0
      end

    end

  end
  ---------

  --confirm option
  if keyJustPressed('accept') then

    if (option.pag[option.pagView][option.select][3] ~= nil) and not option.stop then

      option.stop = true

      --information--
      setTextString('description', option.pag[option.pagView][option.select][3])
      if option.pag[option.pagView][option.select][1]:find('dttp') then setProperty('description.y', 50) else setProperty('description.y', 200) end
      setProperty('keyCacheTxt.y', getProperty('description.y')+getProperty('description.height')+50)
      setProperty('keyCacheTxt.visible', (option.pag[option.pagView][option.select][2]:find(option.toType)) and true or false)
      doTweenAlpha('descriptionAl', 'description', 1, 0.5, 'linear')
      doTweenAlpha('sBgAl', 'sBg', 0.85, 0.5, 'linear')
        ---------

      playSound('clickText', 0.9)

    elseif not option.stop then

      cmd(option.pag[option.pagView][option.select][2], option.pag[option.pagView][option.select][4])

    end

  end

  --NAME UNIT
  if option.stop and ((option.pag[option.pagView][option.select][3] ~= nil)) then

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
            playSound('Metronome_Tick', 0.9)
            break

          end
        end

      end

      --apagar e espaçar--
      if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.BACKSPACE') then keyCache = keyCache:sub(1, -2) playSound('missnote'..getRandomInt(1,3), 0.2) end

      if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.SPACE') then keyCache = keyCache..' ' end
      ---------

      if getPropertyFromClass('flixel.FlxG', 'keys.justPressed.ENTER') and getProperty('description.alpha') == 1 then

        cmd(option.pag[option.pagView][option.select][2]:gsub(option.toType, keyCache))
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
        playSound('dialogueClose', 0.9)

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
    doTweenX('creditsX', 'credits', -getProperty('credits.width'), 20, 'linear')

  end 
end

function onTimerCompleted(tag) if tag == 'rwf' then restartSong(false) end end
