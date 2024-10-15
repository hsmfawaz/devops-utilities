alias lsa="ls -lah"
alias pl="git pull"
alias o7a="cd /root/app"
alias gs="git stash"
alias gc="git add . && git commit -m 'server:wip'"
alias docker_clear_logs="sudo truncate -s 0 /var/lib/docker/containers/**/*-json.log"
alias sc="source ~/.bashrc"
alias dbc="docker compose exec app bash"
alias dcomposer="docker run --rm --interactive --tty   --volume=${PWD}/:/app   --volume ${COMPOSER_HOME:-$HOME/.composer}:/tmp   composer"
alias dnode="sudo docker run -it --rm --volume="$PWD/:/app" --workdir="/app"  node:18-alpine3.17"
alias dclog="docker compose logs -f"
alias compose="docker compose "
alias caddy_reload="docker exec -w /etc/caddy caddy caddy fmt --overwrite && docker exec -w /etc/caddy caddy caddy reload"
alias storage_link="ln -s ${PWD}/storage/app/public public/storage"


function fuzz(){
        file=$(fzf) && vim "$file";
}
function db(){
        NAME=$(docker ps --format "{{.Names}}" | grep -m1 $1)
        echo "opening ${NAME}"

        docker exec -it $NAME bash
}

function docker_stop(){
        docker stop $(docker ps -q)
}

function docker_start_apps(){
        docker ps --filter name=app-* -aq | xargs docker start
}
