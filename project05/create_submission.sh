mkdir -p "05_armstrong_benedict"
cp -r "code" "05_armstrong_benedict/"
cp -r "report/plots" "05_armstrong_benedict/plots"
cp "report/05_armstrong_benedict.pdf" "05_armstrong_benedict/05_armstrong_benedict.pdf"

zip -r "05_armstrong_benedict.zip" "05_armstrong_benedict" -x ./05_armstrong_benedict/code/build/\* ./05_armstrong_benedict/code/.gitignore
rm -r "05_armstrong_benedict"
