for i in {0..9}; do printf $i; done;
echo
for i in {0..9}; do printf "\r %d" $i; sleep 0.5;done
