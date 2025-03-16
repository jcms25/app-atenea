import 'package:cached_network_image/cached_network_image.dart';
import 'package:colegia_atenea/controllers/store_controller.dart';
import 'package:colegia_atenea/controllers/student_parent_teacher_controller.dart';
import 'package:colegia_atenea/utils/app_colors.dart';
import 'package:colegia_atenea/utils/app_textstyle.dart';
import 'package:colegia_atenea/views/custom_widgets/custom_app_bar_widget.dart';
import 'package:colegia_atenea/views/screens/store_screens/products/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SubCategoryListScreen extends StatefulWidget {
  final String
      categoryName; //category name of which we are here to see sub-category
  const SubCategoryListScreen({super.key, required this.categoryName});

  @override
  State<SubCategoryListScreen> createState() => _SubCategoryListScreenState();
}

class _SubCategoryListScreenState extends State<SubCategoryListScreen> {

  StoreController? storeController;
  StudentParentTeacherController? studentParentTeacherController;

  @override
  void initState() {
    super.initState();
    storeController = Provider.of<StoreController>(context,listen: false);
    studentParentTeacherController = Provider.of<StudentParentTeacherController>(context,listen: false);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp){
      storeController?.getSubCategoriesOfCategory(categoryName: widget.categoryName, tiendaToken: studentParentTeacherController?.userdata?.tiendaToken ?? "");

    });
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (res,ctx){
          storeController?.setListOfSubCategory(listOfSubCategory: []);
          Get.back();
        },
        child: Scaffold(
        appBar: CustomAppBarWidget(
          title: Text(
            widget.categoryName,
            style: AppTextStyle.getOutfit600(
                textSize: 22, textColor: AppColors.white),
          ),
          onLeadingIconClicked: () {
            storeController?.setListOfSubCategory(listOfSubCategory: []);
            Get.back();
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: storeController?.searchInSubCategoryList,
                  decoration: InputDecoration(
                    hintText: 'Buscar Productors',
                    border: InputBorder.none,
                    icon: Icon(Icons.search, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Loading indicator
              ScrollConfiguration(behavior: ScrollBehavior().copyWith(overscroll: false), child: Consumer<StoreController>(
                builder: (context,storeController,child){
                  return storeController.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Expanded(
                    child: GridView.builder(
                      itemCount: storeController.filteredData.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemBuilder: (context, index) {
                        final subCategoryItem = storeController.filteredData[index];
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => ProductListScreen(categoryId: "${subCategoryItem.id ?? ""}", categoryName: subCategoryItem.name ?? "",));
                          },
                          child: SubCategoryItem(
                            image: subCategoryItem.image?.src ?? "",
                            title: "${subCategoryItem.name ?? ""}t(${subCategoryItem.count ?? 0})",
                          ),
                        );
                      },
                    ),
                  );
                },
              )),
            ],
          ),
        )
    ));
  }
}




class SubCategoryItem extends StatelessWidget {
  final String image;
  final String title;

  const SubCategoryItem({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ✅ Cached Network Image with Error Handling
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => Container(
                color: Colors.grey[300],
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),

        // Book Title
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 5),

      ],
    );
  }
}