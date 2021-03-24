###################################
# Amethyst
###################################

install with:

```
brew cask install amethyst
```

cycling through open windows

```
j
k
```

changing the size of windows in the layout

```
l
h
```

swap with main display

```
opt + shift + enter
```

switch to specific layouts

```
opt + shift + A # for tall
opt + shift + D # for widescreen
```

cycle through layouts

```
opt + shift + space
```

###################################
# Sketchbook
###################################

Use the viewer (spacebar)
Zoom in/out: spacebar + scroll
Fit canvas to program size: cmd + opt + 0

other useful hotkeys
https://knowledge.autodesk.com/support/sketchbook-products/learn-explore/caas/CloudHelp/cloudhelp/ENU/SKETPRO-Help/files/sb-basics/SKETPRO-Help-sb-basics-hotkey-shortcuts-html-html.html

###################################
# Rectangle
###################################


Useful for snapping individual windows around the display

`brew install rectangle`


###################################
# Divvy
###################################

###################################
# Tmux 
###################################

tmux commands:

mod = ctl+b

sessions:

mod+( - previous session
mod+) - next session
mod+s - session list

windows:

mod+n - next window
mod+p - prev window
mod+w - list windows
mod+& - kill currrent window
mod+, - rename window
mod+z - maxiimize focused window 
mod+. - move window
mod+[i] - go to window [i]

panes:

mod+" - Horizontally split
mod+% - Vertically split
mod+k - go up one pane
mod+j - go down one pane
mod+h - go left one pane
mod+l - go right one pane
mod+x - kill pane
mod+{ - swap pane to the left
mod+} - swap pane to the right


Random:

mod+t - show the time
shift click with a mouse to select text for copying
mod+[ - enter scroll mode

Scroll mode:

ctl+y - scroll up
ctl+e - scroll down

###################################
# Vim
###################################

## Motion

ctl+i - go to next location
ctl+o - go to previous location

## Abbreviations vs snippets

## Text blocks 

## Sessions

* shada file (shared data file)

## Folding

## Modes

* :terminal
  * Exit with <C-\><C-N>
  * follow a file with `gf` (goto file)
  * follow a file with `gF` (goto file)

* :normal
* :insert

## Marks and Jumps

## Quickfix window

## Status Line :statusline

## Diffing

* :Gdiffsplit
  * Jumping to diffs *jumpto-diffs*
  * jump to next diff ]c
  * jump to prev diff [c


## Find and replace

* :s # For more examples visit https://vim.fandom.com/wiki/Search_and_replace

## Find and replace in multiple files

* :cdfo

## netrw

% - create a file
- - go up a directory


## Command-line mode

* you can run commands on a range of lines, % is the same as 1,$ (meaning all the lines of a file)

### Special Characters

% is pretty much the only useful one, it has some useful modifiers

* You can type <C-R><Special character> to exapnd it

### Filename modifiers
							 *filename-modifiers*
:p - full path
:~ - from the home directory
:. - current directory
:h - head of the filename
:t - tail of file name
:r - root of file name
:e - extension of file name


###################################
# Useful shell commands
###################################


ctl+a - go to beginning of line
ctl+e - go to end of line
ctl+f - go forward one character
ctl+b - go back one character
alt+f - go forward one word
alt+b - go back one word
ctl+w - backspace one word
ctl+- - undo previous input
ctl+u - erase line

###################################
# Bash
###################################

ps aux  | grep defunct | grep --invert-match "grep" | while read a b c ; do kill $b ; done # kill defunct processes
for i in {1..22} ; do i+="00" && mix check_discrepancies --slug "messenger" --offset $i --batch-size 100 >> ./messenger_$i && echo "\nmessenger $i\n" >> ./messenger_$i ; done # iterate through a bunch of jobs
###################################
# Docker
###################################


docker ps # list docker processes
docker ps —format ‘{{.Names}}’ # list just the names
docker ps -q # list  all the running containers ids
docker ps —help # very  helpful, list  different switches  for docker ps
docker kill
docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Command}}” #  Example of formatting the output of docker with multiple  fields
docker rm # remove containers
docker kill # kill containers
docker ps --format "table {{.Names}}\t{{.ID}}" --filter name="halberd" --filter status=running # shows me that there are two halberds running…
docker build # create an image from the contents of the current directory
docker stats # shows a live stream of stats
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | grep "\d\d\.\d\d% # show all docker containers running double digit cpu %
docker info -- will show information about docker

docker exec -ti <container_id> /bin/bash # exec into a container
docker run --name anakin --rm -i -t registry.podium.com/engineering/webchat/anakin:dev bash # create a container from an image and exec into it with the given command
docker run --env-file # pass in a list of environment variables

docker system prune # remove all dangling resources (anything not associated with a container)
docker system prune -a 
docker volume prune # remove volumes

### Dynamic Environment stuff
# dyn-env

kafka port - kafka.default.svc.cluster.local

minikube runs one a different instance of docker, so if you want to run docker commands against that environment you have to run `eval $(minikube docker-env)`

docker image rm registry.podium.com/engineering/webchat/anakin:dev -f # Useful command for deleting previously attempted images
docker image ls | grep anakin # list all images you may have been using
helm del —purge anakin # seems to get rid of restarting pods…


# Errors:

Running the seed task would fail. This was because after starting the server it would error out on the consuming/producing of messages to and from kafka.
This was because the libraries to decompress and compress messages were NIFs, written in C, and compiled on a different architecture than the on executing the code.
The error that kept coming back was something like

[NIF failed to load].

After jumping into erlang and logginig the bug, we got the following error:

{:error, {:load_failed, 'Failed to load NIF library: \'/code/_build/dev/lib/snappyer/priv/snappyer.so: invalid ELF header\''}}

The solution ended up being to remove the compiled code from the image and letting the system executing the code do the compilation by adding these lines to the Dockerfile:

```
RUN mix compile && \
  rm -rf _build/dev/lib/snappyer && \
  rm -rf _build/dev/lib/jiffy
```

(Turns out the `_build` directory shouldn't actually be in the docker image... so if you add `_build` to the `.dockerignore` file it works fine)

# build the image
docker build --build-arg MIX_ENV=dev --build-arg HEX_API_PULL_KEY=<key> -f Dockerfile -t path/to/image:tag .


kubectl delete all --all --all-namespaces # to destroy everything in kubernetes...

# install the chart from an image

`helm install --name anakin chartmuseum-dev/helm-chart-generic --values ./values-local.yaml`

###################################
# kubernetes
###################################

Most of the commands to deal with kubernetes involve the `kubectl` cli tool

kubernetes has pods and deployments. The pods are the nodes with services running on them, the deployments will keep them restarting

```
kubectl get pods | grep <pod_name>
kubectl get deployments --all-namespaces
kubectl delete deployment <deployment_name>
```


notes:

Good resource for delete pods that keep getting recreated - https://stackoverflow.com/questions/40686151/kubernetes-pod-gets-recreated-when-deleted

###################################
# K9s
###################################

see a list of all commands with `?`
edit the config of a running pod with `e`

To change memory that kafka or kafka-connect starts up with you can edit the config and change the following:

```
- name: KAFKA_HEAP_OPTS
  value: -Xms512M -Xmx2G
```

from something like `Xmx2GM` to something like `Xmx512M`
`Xms` is the amount that the container will start up with.
`Xmx` is the max amount of memory that the container will ever use.
If you lower `Xmx` to much then it will not perform well with bursts of messages
If you keep `Xmx` close to `Xms` then the memory usage will stay more stable over time

this was a good article on how I found out about this: https://medium.com/wix-engineering/how-to-reduce-your-jvm-app-memory-footprint-in-docker-and-kubernetes-d6e030d21298

list ingres `:ingress`
list namespaces `:ns`
 
 

###################################
# Kafka
###################################

If you want to work with kafka you can use the following commands

kafka-topics.sh --create --zookeeper kafka-zookeeper:2181 --replication-factor 1 --partitions 1 --topic test # create topic
kafka-topics.sh --list --zookeeper kafka-zookeeper:2181 # list all topics

kafka-manager is a tool to show topics, consumers, producers, offsets...

### kafka

Using dynamic environments, we can see what messages are coming off of a topic

shell into the `kafka-connect` pod and run the command 

```
kafka-console-consumer --topic anakin.location_product.v1.json --bootstrap-server kafka:9092 --from-beginning
kafka-topics --list --bootstrap-server kafka:9092 --exclude-internal | while read topic ; do kafka-run-class kafka.tools.GetOffsetShell --broker-list kafka:9092 --topic $topic --time -1 --offsets 1 ; done # Will list the number of messages on each topic in the cluster
```

338 -> 676 -> 1014 -> 1065
338 messages sent two times in a row when we redeployed the server
It feels like somewhere between the 100 and 1000 messages window  the buffer limit gets exceeded.
Inside the kafka-connect app the following are set:

producer.batch.size=65536
producer.buffer.memory=1073741824

the error that we keep seeing is this: Buffering capacity 1048576 exceeded
65536
1048576

65536 * 3 = 196608

196608
1048576

Should we be using a different url than NA80.salesforce.com?

There's a discrepancy in the number of location_products in anakin and the numner of location_flags in halberd.

so, the use case of feedback...

anakin loc flags: 8320, halberd loc flags: 8699
discrepancy of: 379

The numbers are 3657 in anakin and 3218 in halberd which makes for 439 more feedback records in anakin

There was a bug between 2019-09-30 11:00:00 and 2020-10-02 15:52:00

If we query anakins audit logs we see that there were 12 events to remove org products between that timeframe.
Of those 12 orgs there are 328 locations in those orgs. This doesn't account for all locations.


# When working with dyn-env

To create a topic run the following command:

    export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=kafka,app.kubernetes.io/instance=kafka,app.kubernetes.io/component=kafka" -o jsonpath="{.items[0].metadata.name}")
    kubectl --namespace default exec -it $POD_NAME -- kafka-topics.sh --create --zookeeper kafka-zookeeper:2181 --replication-factor 1 --partitions 1 --topic test

To list all the topics run the following command:

    export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=kafka,app.kubernetes.io/instance=kafka,app.kubernetes.io/component=kafka" -o jsonpath="{.items[0].metadata.name}")
    kubectl --namespace default exec -it $POD_NAME -- kafka-topics.sh --list --zookeeper kafka-zookeeper:2181

To start a kafka producer run the following command:

    export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=kafka,app.kubernetes.io/instance=kafka,app.kubernetes.io/component=kafka" -o jsonpath="{.items[0].metadata.name}")
    kubectl --namespace default exec -it $POD_NAME -- kafka-console-producer.sh --broker-list localhost:9092 --topic test

To start a kafka consumer run the following command:

    export POD_NAME=$(kubectl get pods --namespace default -l "app.kubernetes.io/name=kafka,app.kubernetes.io/instance=kafka,app.kubernetes.io/component=kafka" -o jsonpath="{.items[0].metadata.name}")
    kubectl --namespace default exec -it $POD_NAME -- kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning

To connect to your Kafka server from outside the cluster execute the following commands:

    kubectl port-forward --namespace default svc/kafka 9092:9092 &
    echo "Kafka Broker Endpoint: 127.0.0.1:9092"

    PRODUCER:
        kafka-console-producer.sh --broker-list 127.0.0.1:9092 --topic test
    CONSUMER:
        kafka-console-consumer.sh --bootstrap-server 127.0.0.1:9092 --topic test --from-beginning

###################################
# Shell
###################################


# Jobs

ctrl+z - background a job
jobs - list all running jobs
job %[i] - start the ith job


###################################
# Postgres
###################################

SELECT * FROM TABLE -- selects data from a table
SELECT * FROM TABLE WHERE column <operator> criteria -- filter selected value from table
SELECT * FROM TABLE t JOIN TABLE_2 t2 ON t2.id = t1.t2_id -- join
SELECT * FROM TABLE ORDER BY column desc --  order results by the given column descending

You can query jsonb values with stuff from this reference: https://medium.com/hackernoon/how-to-query-jsonb-beginner-sheet-cheat-4da3aa5082a3

SELECT convert_from(e.data, current_setting('server_encoding')) as data FROM events as eq limit 100; -- you can read binary data (bytea)
