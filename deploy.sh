#!/usr/bin/env bash

add_profiled(){
cat <<EOF > /etc/profile.d/telegram-alert.sh
#!/usr/bin/env bash
# Log connections
bash $ALERTSCRIPT_PATH
EOF
}

add_cronjob(){
{ crontab -l; echo "* * * * * /bin/bash $WARNINGSCRIPT_PATH"; } | crontab - 
chmod +x $WARNINGSCRIPT_PATH
}

add_zsh () {
cat <<EOF >> /etc/zsh/zshrc

# Log connections
bash $ALERTSCRIPT_PATH
EOF
}

ALERTSCRIPT_PATH="/opt/ssh-login-alert-telegram/alert.sh"
WARNINGSCRIPT_PATH="/opt/ssh-login-alert-telegram/warning.sh"

echo "Deploying alerts..."
add_profiled
add_cronjob

echo "Check if ZSH is installed.."

HAS_ZSH=$(grep -o -m 1 "zsh" /etc/shells)
if [ ! -z $HAS_ZSH ]; then
    echo "ZSH is installed, deploy alerts to zshrc"
    add_zsh
else
    echo "No zsh detected"
fi

echo "Done!"
