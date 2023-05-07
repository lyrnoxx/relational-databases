#!/bin/bash
psql="psql --username=freecodecamp --dbname=salon --tuples-only -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

main_menu(){
  if [[ $1 ]]
  then
    echo -e "\n$1\n"
  fi
  options=$($psql "select service_id,name from services")
  echo "$options" | while read service_id bar name
  do
    echo -e "$service_id) $name"
  done
  read SERVICE_ID_SELECTED
  service_needed=$($psql "select name from services where service_id=$SERVICE_ID_SELECTED")
  if [[ -z $service_needed ]]
  then 
    main_menu "I could not find that service. What would you like today?"
  else
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($psql "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nWhat's your name"
    read CUSTOMER_NAME
    insert_customer_details=$($psql "insert into customers(phone,name) values('$CUSTOMER_PHONE','$CUSTOMER_NAME')")
    echo -e "\nWhat time would you like to cut?"
    read SERVICE_TIME
    CUSTOMER_ID=$($psql "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    insert_appointment=$($psql "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  else
    echo -e "\nWhat time would you like to cut?"
    read SERVICE_TIME
    CUSTOMER_NAME_N=$($psql "select name from customers where customer_id=$CUSTOMER_ID")
    CUSTOMER_NAME=$(echo $CUSTOMER_NAME_N | sed 's/ //')
    insert_appointment=$($psql "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  fi
  service_name=$($psql "select name from services where service_id=$SERVICE_ID_SELECTED")
  echo -e "\nI have put you down for a$service_name at $SERVICE_TIME, $CUSTOMER_NAME."
  fi
}
main_menu

