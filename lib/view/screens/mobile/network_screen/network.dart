import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/images.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/search_controller.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_search_field.dart';
import 'package:provider/provider.dart';

class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchControllerProvider>(context);
    final mediaQuery = MediaQueryHelper(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        automaticallyImplyLeading: false,
        title: const Text('Networking'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mediaQuery.screenHeight * 0.01,
            ),
            SearchField(controller: searchProvider.searchController, onChanged: (value) {}),
            Padding(
              padding: EdgeInsets.only(left: mediaQuery.screenWidth * 0.04, top: mediaQuery.screenHeight * 0.04),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('People just landed:'),
              ),
            ),

            // Use a horizontal ListView.builder directly
            SizedBox(
              height: mediaQuery.screenHeight * 0.15, // Set a height for the ListView to be visible
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Scroll horizontally
                itemCount: 6, // Number of containers (6 in this case)
                itemBuilder: (context, index) {
                  return Container(
                    width: mediaQuery.screenWidth * 0.6,
                    margin: EdgeInsets.symmetric(horizontal: mediaQuery.screenWidth * 0.06),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 228, 225, 225),
                      borderRadius: BorderRadius.circular(15),
                    ), // Adds spacing between containers
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: Image.asset(
                            AppImages.orcalogo,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(
                          width: mediaQuery.screenWidth * 0.1,
                        ),
                         Text('Hattit Sammit',
                        style: TextStyle(
                          fontSize: mediaQuery.screenWidth * 0.03
                        ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: mediaQuery.screenHeight * 0.02, horizontal: mediaQuery.screenWidth * 0.04),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Random people:'),
              ),
            ),

            // Adding GridView.builder with 2 grids per row
            Padding(
              padding: EdgeInsets.symmetric(horizontal: mediaQuery.screenWidth * 0.04),
              child: SizedBox(
                height: mediaQuery.screenHeight * 0.5, // Adjust height as needed
                child: GridView.builder(
                  // Prevent GridView from scrolling independently
                  itemCount: 8, // Number of grid items (adjust as needed)
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 grids per row
                    crossAxisSpacing: mediaQuery.screenWidth * 0.04, // Spacing between columns
                    mainAxisSpacing: mediaQuery.screenHeight * 0.02, // Spacing between rows
                    childAspectRatio: 3 / 4, // Adjust the aspect ratio as needed
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[300], // Background color for grid items
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: Image.asset(
                              AppImages.orcalogo,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: mediaQuery.screenHeight * 0.02,
                          ),
                           Text('Person $index'),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
