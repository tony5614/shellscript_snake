  
#initialize a snake array
SNAKE_LENGTH=5
SNAKE_DIRECTION="up"
WID=20
HIGH=10
#2D array
#snake    0   1   2   3   4  
#    X  
#    Y
snake_y=(10 10 10 10 10)
snake_x=(6 7 8 9 10)

function snakeUpdate()
{
    #update snake position
    for i in $(seq $((SNAKE_LENGTH-1)) -1  1 );do
        snake_y[i]=${snake_y[((i-1))]}
        snake_x[i]=${snake_x[((i-1))]} 

    done
    case "$SNAKE_DIRECTION" in
        "up")
            snake_y[0]=$((${snake_y[0]}-1))
            ;;
        "down")
            snake_y[0]=$((${snake_y[0]}+1))
            ;;
        "left")
            snake_x[0]=$((${snake_x[0]}-1))
            ;;
        "right")
            snake_x[0]=$((${snake_x[0]}+1))
            ;;
    esac
    #boundary check
    if ((${snake_y[0]}==-1));then
        snake_y[0]=$((HIGH-1))
    fi
    if ((${snake_y[0]}==${HIGH}));then
        snake_y[0]=0
    fi
    if ((${snake_x[0]}==-1));then
        snake_x[0]=$((WID-1))
    fi
    if ((${snake_x[0]}==${WID}));then
        snake_x[0]=0
    fi
}

function getKey()
{   
    #get keystroke
    #-r       :    catch backslash \
    #-s       :    silent, do not echo keystrke
    #-n       ;    catch only 1 character
    #ui       :    save char to "ui"
    #-t 0.01  :    wait 0.01s
    read -rsn1 -t 0.01 ui 
    case "$ui" in
    # $'\x1b' means escape character
    $'\x1b')
        read -rsn2 -t 0.01  direc
        case "$direc" in        
        "[A") SNAKE_DIRECTION="up";;
        "[B") SNAKE_DIRECTION="down";;
        "[C") SNAKE_DIRECTION="right";;
        "[D") SNAKE_DIRECTION="left";;
        esac
        ;;
    esac
}

function draw()
{
    #move cursor to (0,0)
    tput home
    clear

    #show snake
    for i in $(seq 0 $((SNAKE_LENGTH-1)));do
        y=${snake_y[i]}
        x=${snake_x[i]}
        tput cup $y $x
        printf "0"
    done
    #show food
    tput cup $food_y $food_x
    printf "*"
    
    #move cursor to the end
    tput cup 20 21
}

food_y=1
food_x=1
function updateFood()
{

    tput cup 22 1
#    echo ${snake_y[0]} ${snake_x[0]}
#    echo $food_y         $food_x  
    if ((  ${snake_y[0]}==$food_y))&&(( ${snake_x[0]}==$food_x ));then
        food_y=$((RANDOM%HIGH))
        food_x=$((RANDOM%WID))
        ((SNAKE_LENGTH++))
    fi
}

#################---------MAIN---------###########################

echo ${#}
if ((${#} !=1));then
    echo "usage: ./snake 0.5s (speed)"
    exit
fi
    

reset
while true ;do

#main loop
    getKey
    updateFood
    snakeUpdate
    draw 
    sleep "${1}"    

done









