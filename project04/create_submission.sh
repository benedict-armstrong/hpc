mkdir -p "04_armstrong_benedict"
cp -r "code" "04_armstrong_benedict/"
cp -r "report/plots" "04_armstrong_benedict/plots"
cp "report/04_armstrong_benedict.pdf" "04_armstrong_benedict/04_armstrong_benedict.pdf"

zip -r "04_armstrong_benedict.zip" "04_armstrong_benedict" -x ./04_armstrong_benedict/code/build/\* ./04_armstrong_benedict/code/.gitignore
rm -r "04_armstrong_benedict"
