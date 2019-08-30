#!/bin/bash
#Created by Alejandro Augusto Escariz Agosto - 2019
# usage: 
#       SellerItems.sh Seller_id_Num
# Where:
#       SellerItems.sh 	-> Script file name
#       Seller_id_Num	-> Seller id number, or list of sellers id numbers (separated by comma)
# Example:
#       SellerItems.sh 81644614
#       SellerItems.sh 81644614,26321374
#

[[ "$1" = "" ]] && showhelp=1
[[ "showhelp" -eq 1 ]] && echo "usage: UserItems.sh Seller_id_Num"

list_seller_id="$1"
site_id="MLA"
log_file="SellerItems_ML.log"

for seller_id in $(echo $list_seller_id | sed "s/,/ /g"); do
  echo "------- $seller_id" >> $log_file
  curl -s "https://api.mercadolibre.com/sites/$site_id/search?seller_id=$seller_id" | jq -c '.results[]|[.id,.title,.category_id]' | column -t -s'[],"' > items.tmp
  while read LINE; do
	cat_id=`echo $LINE | awk '{ print $NF }'`
	cat_name=`curl -s "https://api.mercadolibre.com/categories/$cat_id" | jq '.name'`
	echo "$LINE	$cat_name" >> $log_file
  done < items.tmp
done

rm -fr items.tmp
