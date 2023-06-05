--Cleaning data in SQL

SELECT *
FROM  PortfolioProject..NashvilleHousing


----------------------------------------------------------------------------------------------

--Standardize data format

SELECT SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject..NashvilleHousing


Update NashvilleHousing
SET SaleDate=CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateCONVERTED Date;

Update NashvilleHousing
SET SaleDateConverted=CONVERT(Date, SaleDate)


-----------------------------------------------------------------------------------------

--Populate Porperty Addresss data

SELECT *
From PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID



SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress is null


-----------------------------------------------------------------------------------------

--Breaking out address into individual columns(Address, City, State)

SELECT PropertyAddress
From PortfolioProject..NashvilleHousing
--WHERE PropertyAddress is null
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress,  1,CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address

From PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress=SUBSTRING(PropertyAddress,  1,CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity=SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From PortfolioProject..NashvilleHousing



Select OwnerAddress
From PortfolioProject..NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3) AS Address
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2) AS City
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1) AS State
From PortfolioProject..NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress=PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity=PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState=PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

Select *
From PortfolioProject..NashvilleHousing


-----------------------------------------------------------------------------------------

--Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' then 'Yes'
       WHEN SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant 
	   END
From PortfolioProject..NashvilleHousing


UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' then 'Yes'
       WHEN SoldAsVacant = 'N' then 'No'
	   ELSE SoldAsVacant 
	   END


------------------------------------------------------------------------------------------

--Remove Duplication


WITH RowNumCTE AS(
SELECT *, 
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDATE,
				 LegalReference
				 ORDER BY
				    UniqueID
					) row_num
From PortfolioProject..NashvilleHousing
--ORDER BY ParcelID
)
--DELETE
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress
 


SELECT *
From PortfolioProject..NashvilleHousing


------------------------------------------------------------------------------------------


--Delete Unused Columns


SELECT *
From PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate
