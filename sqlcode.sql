--cleaning data in sql quries 

select *
from Portfolio_Project.dbo.NashvilleHousing


--standardize Data format 

select saledateconverted,convert(date,saledate) 
from Portfolio_Project.dbo.NashvilleHousing

Update Portfolio_Project.dbo.NashvilleHousing
set SaleDate=convert(date,SaleDate) 

ALTER TABLE  Portfolio_Project.dbo.NashvilleHousing  
add SaleDateConverted Date

Update Portfolio_Project.dbo.NashvilleHousing
set SaleDateConverted=convert(date,SaleDate) 





--populate property address data 

select *
from  Portfolio_Project.dbo.NashvilleHousing
--where propertyAddress is Null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.propertyAddress,b.PropertyAddress)
from  Portfolio_Project.dbo.NashvilleHousing a 
join  Portfolio_Project.dbo.NashvilleHousing b 
 on a.ParcelID=b.ParcelID
 AND a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

 update a
 set PropertyAddress=ISNULL(a.propertyAddress,b.PropertyAddress)
 from  Portfolio_Project.dbo.NashvilleHousing a 
join  Portfolio_Project.dbo.NashvilleHousing b 
 on a.ParcelID=b.ParcelID
 AND a.[UniqueID ]<>b.[UniqueID ]
 where a.PropertyAddress is null

--breaking th address into individual columns (address,city,state)
select PropertyAddress
from  Portfolio_Project.dbo.NashvilleHousing
--where propertyAddress is Null
--order by ParcelID

select substring(PropertyAddress,1,CHARINDEX(',',propertyAddress)-1) as Address,
substring(PropertyAddress,CHARINDEX(',',propertyAddress) +1 ,LEN(propertyaddress)) as address 

from  Portfolio_Project.dbo.NashvilleHousing


ALTER TABLE  Portfolio_Project.dbo.NashvilleHousing  
add propertysplitaddress nvarchar(255)

Update Portfolio_Project.dbo.NashvilleHousing
set propertysplitaddress=substring(PropertyAddress,1,CHARINDEX(',',propertyAddress)-1)


ALTER TABLE  Portfolio_Project.dbo.NashvilleHousing  
add propertysplitcity nvarchar(255)

Update Portfolio_Project.dbo.NashvilleHousing
set  propertysplitcity=substring(PropertyAddress,CHARINDEX(',',propertyAddress) +1 ,LEN(propertyaddress))


select *
from  Portfolio_Project.dbo.NashvilleHousing




select owneraddress
from Portfolio_Project.dbo.NashvilleHousing

select parsename(replace(owneraddress,',','.'),3),
 parsename(replace(owneraddress,',','.'),2),
 parsename(replace(owneraddress,',','.'),1)
from Portfolio_Project.dbo.NashvilleHousing



ALTER TABLE  Portfolio_Project.dbo.NashvilleHousing  
add ownersplitaddress nvarchar(255)

Update Portfolio_Project.dbo.NashvilleHousing
set ownersplitaddress=parsename(replace(owneraddress,',','.'),3)


ALTER TABLE  Portfolio_Project.dbo.NashvilleHousing  
add ownersplitcity nvarchar(255)

Update Portfolio_Project.dbo.NashvilleHousing
set  ownersplitcity=parsename(replace(owneraddress,',','.'),2)


ALTER TABLE  Portfolio_Project.dbo.NashvilleHousing  
add ownersplitstate nvarchar(255)

Update Portfolio_Project.dbo.NashvilleHousing
set  ownersplitstate=parsename(replace(owneraddress,',','.'),1)

select *
from Portfolio_Project.dbo.NashvilleHousing


---change Y and N to YES and NO in "solid as vacant "field

select Distinct(soldasvacant),count(soldasvacant)
from Portfolio_Project.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select soldasvacant
,case when  soldasvacant='N' then  'NO'
      when   soldasvacant='Y'then  'YES'
	  ELSE   soldasvacant 
	 end
from Portfolio_Project.dbo.NashvilleHousing


UPDATE Portfolio_Project.dbo.NashvilleHousing
set SoldAsVacant=case when  soldasvacant='N' then  'NO'
      when   soldasvacant='Y'then  'YES'
	  ELSE   soldasvacant 
	 end


---remove duplicates 
with rownumcte as (
select *,ROW_NUMBER() over (
         partition by parcelID,propertyaddress,saleprice,saledate,legalreference
		 order by uniqueid) row_num

from Portfolio_Project.dbo.NashvilleHousing
--order by ParcelID
)


select *
from rownumcte
where row_num>1
--order by PropertyAddress



--deleted unused columns 

select *
from Portfolio_Project.dbo.NashvilleHousing

alter table  Portfolio_Project.dbo.NashvilleHousing
drop column owneraddress,taxdistrict,propertyaddress


