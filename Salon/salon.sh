#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then 
    echo -e "\n$1"
  fi
  
  echo -e "Welcome to My Salon, how can I help you?\n"
  SERVICE_MENU=$($PSQL "SELECT service_id, name FROM services WHERE name IN('cut', 'color', 'perm', 'style', 'trim') ORDER BY service_id")
  echo "$SERVICE_MENU" | while read ID BAR NAME
  do
    echo -e "$ID) $NAME"
  done

  read SERVICE_ID_SELECTED

  if [[ ! $SERVICE_ID_SELECTED =~ ^[1-5]$ ]]
  then 
    MAIN_MENU "I could not find that service. What would you like today?"
  else 
    SERVICE
  fi
}

SERVICE() {
  # get customer
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # if customer doesn"t exist
  if [[ -z $CUSTOMER_NAME ]]
  then 
    # get new customer
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME

    # insert new customer
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  fi

  # appointment info
  SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  echo -e "\nWhat time would you like your $(echo "$SERVICE_NAME" | sed 's/ //'), $(echo "$CUSTOMER_NAME" | sed 's/ //')?"
  read SERVICE_TIME

  # insert into appointments
  INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES((SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'), (SELECT service_id FROM services WHERE name='$(echo "$SERVICE_NAME" | sed 's/ //')'), '$SERVICE_TIME')")
  echo -e "\nI have put you down for a $(echo "$SERVICE_NAME" | sed 's/ //') at $SERVICE_TIME, $(echo "$CUSTOMER_NAME" | sed 's/ //').\n"


}

MAIN_MENU

