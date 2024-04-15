mkdir -p "03_armstrong_benedict"
cp -r "code" "03_armstrong_benedict/"
cp -r "report/plots" "03_armstrong_benedict/plots"
cp "report/03_armstrong_benedict.pdf" "03_armstrong_benedict/03_armstrong_benedict.pdf"

zip -r "03_armstrong_benedict.zip" "03_armstrong_benedict" -x ./03_armstrong_benedict/code/build/\* ./03_armstrong_benedict/code/.gitignore
rm -r "03_armstrong_benedict"
