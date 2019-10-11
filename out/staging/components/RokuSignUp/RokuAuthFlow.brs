' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********

' Component initialization, setting default properties, configuring observers (handlers)
sub init()
    print ">>> RokuAuthFlow :: init()"

    m.indexButtonGo = 0
    m.indexButtonBack = 1
    m.indexButtonPasswordShowHide = 0
    m.indexButtonPortGo = 1
    m.indexButtonPortBack = 2
    m.indexButtonUserGo = 1
    m.indexButtonUserBack = 2
    m.indexButtonPasswordGo = 1
    m.indexButtonPasswordBack = 2

    m.top.kbdialogEmail = CreateObject("roSGNode", "BackKeyboardDialog")
    m.top.kbdialogEmail.title = "Enter the email address"
    m.top.kbdialogEmail.text = ""
    m.top.kbdialogEmail.buttons = ["Continue", "Back"]
    m.top.kbdialogEmail.ObserveField("buttonSelected", "On_kbdialogEmail_buttonSelected")

    m.top.kbdialogServer = CreateObject("roSGNode", "BackKeyboardDialog")
    m.top.kbdialogServer.title = "Enter the server address"
    m.top.kbdialogServer.text = "https://media.famgala.com"
    m.top.kbdialogServer.buttons = ["Continue", "Back"]
    m.top.kbdialogServer.ObserveField("buttonSelected", "On_kbdialogServer_buttonSelected")

    m.top.kbdialogPort = CreateObject("roSGNode", "BackKeyboardDialog")
    m.top.kbdialogPort.title = "Enter the port number"
    m.top.kbdialogPort.text = ""
    m.top.kbdialogPort.buttons = ["Continue", "Back"]
    m.top.kbdialogPort.ObserveField("buttonSelected", "On_kbdialogPort_buttonSelected")

    m.top.kbdialogUser = CreateObject("roSGNode", "BackKeyboardDialog")
    m.top.kbdialogUser.title = "Enter the user"
    m.top.kbdialogUser.text = ""
    m.top.kbdialogUser.buttons = ["Continue", "Back"]
    m.top.kbdialogUser.ObserveField("buttonSelected", "On_kbdialogUser_buttonSelected")

    m.top.kbdialogPassword = CreateObject("roSGNode", "BackKeyboardDialog")
    m.top.kbdialogPassword.title = "Enter the password"
    m.top.kbdialogPassword.text = ""
    m.top.kbdialogPassword.buttons = ["Show/hide password", "Continue", "Back"]
    m.top.kbdialogPassword.keyboard.textEditBox.secureMode = true
    m.top.kbdialogPassword.ObserveField("buttonSelected", "On_kbdialogPassword_buttonSelected")

    m.top.dialogErrEmail = CreateObject("roSGNode", "BackDialog")
    m.top.dialogErrEmail.title = "Email input error"
    m.top.dialogErrEmail.message = "Please enter a valid email address"
    m.top.dialogErrEmail.buttons = ["OK"]
    m.top.dialogErrEmail.ObserveField("buttonSelected", "On_dialogErrEmail_buttonSelected")

    m.top.dialogErrServer = CreateObject("roSGNode", "BackDialog")
    m.top.dialogErrServer.title = "Server input error"
    m.top.dialogErrServer.message = "Please enter a valid server address"
    m.top.dialogErrServer.buttons = ["OK"]
    m.top.dialogErrServer.ObserveField("buttonSelected", "On_dialogErrServer_buttonSelected")

    m.top.dialogErrPort = CreateObject("roSGNode", "BackDialog")
    m.top.dialogErrPort.title = "Port input error"
    m.top.dialogErrPort.message = "Please enter a valid port"
    m.top.dialogErrPort.buttons = ["OK"]
    m.top.dialogErrPort.ObserveField("buttonSelected", "On_dialogErrPort_buttonSelected")

    m.top.dialogErrUser = CreateObject("roSGNode", "BackDialog")
    m.top.dialogErrUser.title = "User input error"
    m.top.dialogErrUser.message = "Please enter a valid user"
    m.top.dialogErrUser.buttons = ["OK"]
    m.top.dialogErrUser.ObserveField("buttonSelected", "On_dialogErrUser_buttonSelected")

    m.top.dialogErrPassword = CreateObject("roSGNode", "BackDialog")
    m.top.dialogErrPassword.title = "Password input error"
    m.top.dialogErrPassword.message = "Please enter non-empty password"
    m.top.dialogErrPassword.buttons = ["OK"]
    m.top.dialogErrPassword.ObserveField("buttonSelected", "On_dialogErrPassword_buttonSelected")

    m.top.dialogTermsOfUse = CreateObject("roSGNode", "BackDialog")
    m.top.dialogTermsOfUse.title = "Terms Of Use"
    m.top.dialogTermsOfUse.message = ""  'if empty string then not shown to the user, set from your app if needed
    m.top.dialogTermsOfUse.buttons = ["Accept", "Decline"]
    m.top.dialogTermsOfUse.ObserveField("buttonSelected", "On_dialogTermsOfUse_buttonSelected")

    m.top.pdialogAuth = CreateObject("roSGNode", "ProgressDialog")
    m.top.pdialogAuth.title = "Please wait..."

    m.top.dialogAuthFailed = CreateObject("roSGNode", "BackDialog")
    m.top.dialogAuthFailed.title = "Authentication failed"
    m.top.dialogAuthFailed.buttons = ["Try again", "Cancel"]
    m.top.dialogAuthFailed.ObserveField("buttonSelected", "On_dialogAuthFailed_buttonSelected")

    m.top.ObserveField("userData", "On_userData")

    print "<<< RokuAuthFlow :: init()"
end sub


' Email address validation. Returns True if given email address matches regexEmail, false otherwise.
function IsValidEmail(email as String) as Boolean
    return CreateObject("roRegex", m.top.regexEmail, "i").IsMatch(email)
end function

function IsValidServer(server as String) as Boolean
    return CreateObject("roRegex", m.top.regexServer, "i").IsMatch(server)
end function

function IsValidPort(port as String) as Boolean
    return CreateObject("roRegex", m.top.regexPort, "i").IsMatch(port)
end function

function IsValidUser(user as String) as Boolean
    return CreateObject("roRegex", m.top.regexUser, "i").IsMatch(user)
end function

' Password validation. Returns True if given password matches regexPassword, false otherwise.
function IsValidPassword(password as String) as Boolean
    return CreateObject("roRegex", m.top.regexPassword, "i").IsMatch(password)
end function


' Populates user data (email address and password) from related keyboard dialogs
sub Set_userData()
    userData = {
'        email       : m.top.kbdialogEmail.text
        server    : m.top.kbdialogServer.text
        port    : m.top.kbdialogPort.text
        user    : m.top.kbdialogUser.text
        password    : m.top.kbdialogPassword.text
    }
    m.parentScene.dialog.close = true
    m.top.userData = userData
    base = server + port
    set_setting()
end sub
' set server data.  isolate server + users
sub Set_serverData()
    userData = {
'        email       : m.top.kbdialogEmail.text
        server    : m.top.kbdialogServer.text
        port    : m.top.kbdialogPort.text
    }
    m.parentScene.dialog.close = true
    m.top.serverData = serverData
    base = server + port

end sub
' Jellyfin - set login details
sub Set_loginData()
    loginData = {
        server       : m.top.kbdialogServer.text
        port       : m.top.kbdialogPort.text
        user       : m.top.kbdialogUser.text
        password    : m.top.kbdialogPassword.text
    }
    m.parentScene.dialog.close = true
    m.top.loginData = loginData
end sub


' onChange handler for "show" field
sub On_show()
    print "RokuAuthFlow :: On_show()"
    if GetParentScene() = invalid then
        return
    end if

'    m.top.kbdialogEmail.focusButton = m.indexButtonGo
    m.top.kbdialogServer.focusButton = m.indexButtonGo
    m.top.kbdialogPort.text = "8098"
    m.top.kbdialogPort.focusButton = m.indexButtonGo
    m.top.kbdialogUser.text = "abc"
    m.top.kbdialogUser.focusButton = m.indexButtonGo
    m.top.kbdialogPassword.text = ""
    m.top.kbdialogPassword.focusButton = m.indexButtonPasswordShowHide
'    m.parentScene.dialog = m.top.kbdialogEmail
    m.parentScene.dialog = m.top.kbdialogServer
end sub


' Handler for processing email address KeyboardDialog button selection
sub On_kbdialogEmail_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if

    if m.top.kbdialogEmail.buttonSelected = m.indexButtonGo then
        if IsValidEmail(m.top.kbdialogEmail.text) then
            m.parentScene.dialog = m.top.kbdialogPassword
        else
            m.parentScene.dialog = m.top.dialogErrEmail
        end if

    else if m.top.kbdialogEmail.buttonSelected = m.indexButtonBack OR m.top.kbdialogEmail.buttonSelected < 0 then
        m.parentScene.dialog.close = true
        m.parentScene.dialog = invalid
        m.top.isAuthorized = false

    end if
end sub

' Handler for processing server address KeyboardDialog button selection
sub On_kbdialogServer_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if

    if m.top.kbdialogServer.buttonSelected = m.indexButtonGo then
        if IsValidServer(m.top.kbdialogServer.text) then
            m.parentScene.dialog = m.top.kbdialogPort
        else
            m.parentScene.dialog = m.top.dialogErrServer
        end if

    else if m.top.kbdialogServer.buttonSelected = m.indexButtonBack OR m.top.kbdialogServer.buttonSelected < 0 then
        m.parentScene.dialog.close = true
        m.parentScene.dialog = invalid
        m.top.isAuthorized = false

    end if
end sub
' Handler for processing port address KeyboardDialog button selection
sub On_kbdialogPort_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if

    if m.top.kbdialogPort.buttonSelected = m.indexButtonGo then
        if IsValidPort(m.top.kbdialogPort.text) then
            m.parentScene.dialog = m.top.kbdialogUser
        else
            m.parentScene.dialog = m.top.dialogErrPort
        end if

    else if m.top.kbdialogPort.buttonSelected = m.indexButtonBack OR m.top.kbdialogPort.buttonSelected < 0 then
        m.parentScene.dialog.close = true
        m.parentScene.dialog = invalid
        m.top.isAuthorized = false

    end if
end sub
' Handler for processing user address KeyboardDialog button selection
sub On_kbdialogUser_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if

    if m.top.kbdialogUser.buttonSelected = m.indexButtonGo then
        if IsValidUser(m.top.kbdialogUser.text) then
            m.parentScene.dialog = m.top.kbdialogPassword
        else
            m.parentScene.dialog = m.top.dialogErrUser
        end if

    else if m.top.kbdialogUser.buttonSelected = m.indexButtonBack OR m.top.kbdialogUser.buttonSelected < 0 then
        m.parentScene.dialog.close = true
        m.parentScene.dialog = invalid
        m.top.isAuthorized = false

    end if
end sub

' Handler for processing email address error Dialog button selection
sub On_dialogErrEmail_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if
    m.parentScene.dialog = m.top.kbdialogEmail
end sub
' Handler for processing server address error Dialog button selection
sub On_dialogErrServer_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if
    m.parentScene.dialog = m.top.kbdialogServer
end sub
' Handler for processing Port error Dialog button selection
sub On_dialogErrPort_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if
    m.parentScene.dialog = m.top.kbdialogPort
end sub
' Handler for processing User error Dialog button selection
sub On_dialogErrUser_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if
    m.parentScene.dialog = m.top.kbdialogUser
end sub

' Handler for processing password KeyboardDialog button selection
sub On_kbdialogPassword_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if

    if m.top.kbdialogPassword.buttonSelected = m.indexButtonPasswordGo then
        if IsValidPassword(m.top.kbdialogPassword.text) then
            if m.top.dialogTermsOfUse.message.Len() = 0 then
                Set_userData()
            else
                m.top.dialogTermsOfUse.focusButton = m.indexButtonGo
                m.parentScene.dialog = m.top.dialogTermsOfUse
            end if
        else
            m.parentScene.dialog = m.top.dialogErrPassword
        end if

    else if m.top.kbdialogPassword.buttonSelected = m.indexButtonPasswordBack OR m.top.kbdialogPassword.buttonSelected < 0 then
'        m.parentScene.dialog = m.top.kbdialogEmail
        m.parentScene.dialog = m.top.kbdialogUser
    else if m.top.kbdialogPassword.buttonSelected = m.indexButtonPasswordShowHide then
        m.parentScene.dialog.keyboard.textEditBox.secureMode = not m.parentScene.dialog.keyboard.textEditBox.secureMode

    end if
end sub


' Handler for processing password error Dialog button selection
sub On_dialogErrPassword_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if
    m.parentScene.dialog = m.top.kbdialogPassword
end sub


' Handler for processing Terms-Of-Use Dialog button selection
sub On_dialogTermsOfUse_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if

    if m.top.dialogTermsOfUse.buttonSelected = m.indexButtonGo then
        Set_userData()
    else if m.top.dialogTermsOfUse.buttonSelected < 0
        m.parentScene.dialog = m.top.kbdialogPassword
    else
        m.parentScene.dialog = m.top.kbdialogEmail
    end if
end sub


' Handler for processing user data (email address, password) collected from related dialogs
sub On_userData()
    m.parentScene.dialog = m.top.pdialogAuth
end sub


' onChange handler for "isAPISuccess" field
sub On_isAPISuccess()
    if GetParentScene() = invalid then
        return
    end if
    if m.top.isAPISuccess then
        m.top.isAuthorized = true
    else
        m.parentScene.dialog = m.top.dialogAuthFailed
    end if
end sub


' Handler for processing auth failure Dialog button selection
sub On_dialogAuthFailed_buttonSelected()
    if GetParentScene() = invalid then
        return
    end if
    if m.top.dialogAuthFailed.buttonSelected = m.indexButtonGo then
        m.parentScene.dialog = m.top.kbdialogEmail
    else
        m.parentScene.dialog.close = true
        m.top.isAuthorized = false
    end if
end sub
'
