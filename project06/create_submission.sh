mkdir -p "06_armstrong_benedict"
cp -r "code" "06_armstrong_benedict/"
cp -r "report/plots" "06_armstrong_benedict/plots"
cp "report/06_armstrong_benedict.pdf" "06_armstrong_benedict/06_armstrong_benedict.pdf"

zip -r "06_armstrong_benedict.zip" "06_armstrong_benedict" -x ./06_armstrong_benedict/code/.gitignore
rm -r "06_armstrong_benedict"
