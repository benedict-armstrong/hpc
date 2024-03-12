mkdir -p "01_armstrong_benedict"
cp -r "01a" "01_armstrong_benedict/01a"
cp -r "01b" "01_armstrong_benedict/01b"
cp "report/01_armstrong_benedict.pdf" "01_armstrong_benedict/01_armstrong_benedict.pdf"

zip -r "01_armstrong_benedict.zip" "01_armstrong_benedict"
rm -r "01_armstrong_benedict"
