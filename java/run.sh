  #!/bin/sh

  #所有jar文件
  files=$(find . -name "*.jar")

  JAR_PATH_NAME=${files[0]}
  #jar包名称
  JAR_NAME=${JAR_PATH_NAME#*/}

  #进程PID
  PID=$API_NAME\.pid


  #使用说明，用来提示输入参数
  usage(){
      echo "Usage: sh 执行脚本.sh [start|stop|restart|status|console]"
      exit 1
  }

  #检查程序是否在运行
  is_exist(){
      PID=`ps -ef | grep -n ${JAR_NAME} | grep -v grep | awk '{print $2}'`
      if [ -z "${PID}" ]; then
         return 1
        else
          return 0
        fi
   }

  #运行状态
  status(){
    is_exist
    if [ $? -eq "0" ]; then
      echo "=== [${JAR_NAME}] is running, PID is ${PID} ==="
    else
      echo "=== [${JAR_NAME}] is not running ==="
    fi
   }

  #后台启动 输出日志到log.log文件
  start(){
    is_exist
    if [ $? -eq "0" ]; then
      echo "=== [${JAR_NAME}] is already running PID=${PID} ==="
    else
      nohup java -jar ${JAR_NAME} >log.log 2>&1 &
      echo $! > $PID
      echo "=== start [${JAR_NAME}] successed PID=$! ==="
     fi
    }


  #前台启动
  console(){
    is_exist
    if [ $? -eq "0" ]; then
      echo "=== [${JAR_NAME}] is already running PID=${PID} ==="
    else
      java -jar ${JAR_NAME}
     fi
    }

  #停止进程
  stop(){
    #is_exist
    pidf=$(cat ${PID})
    #输出
    echo "=== [${JAR_NAME}] PID = $pidf begin kill $pidf ==="
    kill $pidf
    rm -rf ${PID}
    sleep 2
    is_exist
    if [ $? -eq "0" ]; then
      echo "=== [${JAR_NAME}] PID = ${PID} begin kill -9 ${PID}  ==="
      kill -9  ${PID}
      sleep 2
      echo "=== [${JAR_NAME}] process stopped ==="
    else
      echo "=== [${JAR_NAME}] is not running ==="
    fi
  }

  #重启
  restart(){
    stop
    start
  }

  #根据输入参数，选择执行对应方法，不输入则执行使用说明
  case "$1" in
    "start")
      start
      ;;
    "console")
      console
      ;;
    "stop")
      stop
      ;;
    "status")
      status
      ;;
    "restart")
      restart
      ;;
    *)
      usage
      ;;
  esac
  exit 0
  