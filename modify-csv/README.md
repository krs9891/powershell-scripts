# DevOps Essentials: Powershell Task 2

> **Please use branch `task2` for this task that already exist in your forked repository after you has been started task**

## Powershell Task 2

Company ABC has uncontrolled process of employee’s accounts creation. Currently process means
adding names, email and other personal data manually to the accounts.csv file without any rules.
Department head has decided to improve it based on the naming convention implementation. Good
idea for newcomers, but what to do with current user’s list? You have been asked to help. Could you please
develop automated way (powershell script) and create new accounts_new.csv file based on current
accounts.csv and below.

## Task requirements

1) Need to update column name.

    Name format: first letter of name/surname uppercase and all other letters lowercase.

2) Need to update column email with domain @abc.

    Email format: first letter from name and full surname, lowercase.

    Equals emails should contain location_id.

3) Sripts should has name task2.ps1

4) Path to accounts.csv file should be as argument to the script.

5) Result file accounts_new.csv should be created in the same directory where accounts.csv file is located (**NOTE:** it can be different than current folder)

## Definition of done.

Developed powershell script which automatically creates accounts_new.csv and updates columns name and email based on the rules above.

## Example:
```powershell
./task2.ps1 path/to/accounts.csv
```
### path/to/accounts.csv was:
```csv
8,6,Bart charlow,Executive Director,,
9,7,Bart Charlow,Executive Director,,
```
### path/to/accounts_new.csv became:
```csv
8,6,Bart Charlow,Executive Director,bcharlow6@abc.com,
9,7,Bart Charlow,Executive Director,bcharlow7@abc.com,
```
