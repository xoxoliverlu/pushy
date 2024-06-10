./pushy-init
touch a b
./pushy-add a b
./pushy-commit -m "first commit"
rm a
./pushy-commit -m "second commit"
./pushy-add a
./pushy-commit -m "second commit"
./pushy-rm --cached b
./pushy-commit -m "second commit"
./pushy-rm b
./pushy-add b
./pushy-rm b
./pushy-commit -m "third commit"
./pushy-rm b


./pushy-init
echo 1 >a
echo 2 >b
echo 3 >c
./pushy-add a b c
./pushy-commit -m "first commit"
echo 4 >>a
echo 5 >>b
echo 6 >>c
echo 7 >d
echo 8 >e
./pushy-add b c d e
echo 9 >b
echo 0 >d
./pushy-rm --cached a c
./pushy-rm --force --cached b
./pushy-rm --force --cached e
./pushy-rm --force d
./pushy-status


./pushy-init
touch a b c d e f g h
./pushy-add a b c d e f
./pushy-commit -m "first commit"
echo hello >a
echo hello >b
echo hello >c
./pushy-add a b
echo world >a
rm d
./pushy-rm e
./pushy-add g
./pushy-status

./pushy-init
echo hi >a
./pushy-add a
./pushy-commit -m message
echo hello >b
echo hola >c
./pushy-add b c
./pushy-status
echo there >>b
rm c
./pushy-status