import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:orca_social_media/constants/images.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/controllers/search_controller.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:orca_social_media/view/screens/mobile/network_screen/users_list.dart';
import 'package:orca_social_media/view/widgets/mobile/custom_search_field.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchControllerProvider>(context);
    final mediaQuery = MediaQueryHelper(context);
    final userProvider = Provider.of<UserProvider>(context);
    
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
            mediaQuery.screenHeight * 0.15), // Adjust height as needed
        child: AppBar(
          elevation: 3,
          automaticallyImplyLeading: false,
          flexibleSpace: Padding(
            padding: EdgeInsets.only(
              top: mediaQuery.screenHeight * 0.02,
              left: mediaQuery.screenWidth * 0.04,
              right: mediaQuery.screenWidth * 0.04,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Networking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: mediaQuery.screenHeight * 0.01),
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return  SearchField(
                    controller: searchProvider.searchController,
                    onChanged: (value) {
                      userProvider.filterUsers(value);
                    },
                  );
                  },
                
                ),
              ],
            ),
          ),
        ),
      ),
      body:searchProvider.searchController.text.isNotEmpty?
    ChangeNotifierProvider(
  create: (context) => UserProvider()..fetchAndSetUsers(),
  child: Consumer<UserProvider>(
    builder: (context, userProvider, child) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userProvider.filteredUsers.length,
              itemBuilder: (context, index) {
                final user = userProvider.filteredUsers[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: user.profilPicture != null
                        ? NetworkImage(user.profilPicture!)
                        : null,
                    child: user.profilPicture == null ? Icon(Icons.person) : null,
                  ),
                  title: Text(user.username),
                  subtitle: Text(user.nickname),
                );
              },
            ),
          ),
        ],
      );
    },
  ),
):

         
       SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: mediaQuery.screenHeight * 0.01,
            ),

            Padding(
              padding: EdgeInsets.only(
                  left: mediaQuery.screenWidth * 0.04,
                  top: mediaQuery.screenHeight * 0.04),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('People just landed:'),
              ),
            ),

            // Use a horizontal ListView.builder directly
            SizedBox(
              height: mediaQuery.screenHeight *
                  0.15, // Set a height for the ListView to be visible
              child: ChangeNotifierProvider(
                create: (_) => UserProvider()..fetchAndSetUsers(),
                child: Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    final users = userProvider.allUsers;
                    final justlandedUsers = users.take(5).toList();

                    return FutureBuilder(
                      future: userProvider.fetchAllUsers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListView.builder(
                            scrollDirection:
                                Axis.horizontal, // Scroll horizontally
                            itemCount: 6, // Placeholder count
                            itemBuilder: (context, index) {
                              return Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: mediaQuery.screenWidth * 0.6,
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                          mediaQuery.screenWidth * 0.06),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 228, 225, 225),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors
                                            .grey[200], // Placeholder color
                                      ),
                                      SizedBox(
                                        width: mediaQuery.screenWidth * 0.1,
                                      ),
                                      Container(
                                        width: 80,
                                        height: 20,
                                        color: Colors
                                            .grey[300], // Placeholder for text
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                            snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection:
                                Axis.horizontal, // Scroll horizontally
                            itemCount: justlandedUsers
                                .length, // Number of containers (6 in this case)
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return Container(
                                width: mediaQuery.screenWidth * 0.6,
                                margin: EdgeInsets.symmetric(
                                    horizontal: mediaQuery.screenWidth * 0.06),
                                decoration: BoxDecoration(
                                  color:
                                      const Color.fromARGB(255, 228, 225, 225),
                                  borderRadius: BorderRadius.circular(15),
                                ), // Adds spacing between containers
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      child: ClipOval(
                                        child: CachedNetworkImage(
                                          imageUrl: user.profilPicture,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              Shimmer.fromColors(
                                            baseColor: Colors.grey[
                                                300]!, // Base color for shimmer
                                            highlightColor: Colors.grey[
                                                100]!, // Highlight color for shimmer
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundColor: Colors.grey[
                                                  200], // Placeholder color
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(AppImages
                                                .orcalogo), // Fallback image
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: mediaQuery.screenWidth * 0.1,
                                    ),
                                    Text(
                                      user.username,
                                      style: TextStyle(
                                          fontSize:
                                              mediaQuery.screenWidth * 0.03),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text('some error occured'),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: mediaQuery.screenHeight * 0.02,
                  horizontal: mediaQuery.screenWidth * 0.04),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Random people:'),
              ),
            ),

            // Adding GridView.builder with 2 grids per row
            ChangeNotifierProvider(
              create: (context) => UserProvider()..fetchAndSetUsers(),
              child: Consumer<UserProvider>(
                builder: (context, rondomPProvider, child) {
                  final randomPeople = rondomPProvider.allUsers;
                  final randomUsers = randomPeople.skip(5).toList();
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: mediaQuery.screenWidth * 0.04),
                    child: SizedBox(
                      height: mediaQuery.screenHeight *
                          0.5, // Adjust height as needed
                      child: GridView.builder(
                        // Prevent GridView from scrolling independently
                        itemCount: randomUsers
                            .length, // Number of grid items (adjust as needed)
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // 2 grids per row
                          crossAxisSpacing: mediaQuery.screenWidth *
                              0.04, // Spacing between columns
                          mainAxisSpacing: mediaQuery.screenHeight *
                              0.02, // Spacing between rows
                          childAspectRatio:
                              3 / 4, // Adjust the aspect ratio as needed
                        ),
                        itemBuilder: (context, index) {
                          final userR = randomUsers[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors
                                  .grey[300], // Background color for grid items
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                    radius: 50,
                                    child: ClipOval(
                                        child: CachedNetworkImage(
                                      imageUrl: userR.profilPicture,
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        );
                                      },
                                    ))),
                                SizedBox(
                                  height: mediaQuery.screenHeight * 0.02,
                                ),
                                Text(userR.username),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
