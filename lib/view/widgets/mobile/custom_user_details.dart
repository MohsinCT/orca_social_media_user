import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orca_social_media/constants/colors.dart';
import 'package:orca_social_media/constants/media_query.dart';
import 'package:orca_social_media/controllers/auth/register.dart';
import 'package:orca_social_media/models/register_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQueryHelper(context);

    return FutureBuilder<UserModel?>(
      future:
          Provider.of<UserProvider>(context, listen: false).fetchUserDetails(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildShimmerEffect(mediaQuery);
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          final user = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: mediaQuery.screenHeight * 0.04,
                  ),
                  child: ListTile(
                    leading: // Ensures the image fits inside the circle
                        Container(
                      width: mediaQuery.screenWidth *
                          0.15, // Set the desired size (diameter)
                      height: mediaQuery.screenHeight *
                          9, // Ensure width and height are equal for a circle
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Makes the container circular
                        border: Border.all(
                            color: Colors.grey, width: 2), // Optional border
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user.profilPicture,
                          width: 150, // Match the size of the container
                          height: 150,
                          fit: BoxFit
                              .cover, // Ensures the image fits properly inside the circle
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(), // Optional placeholder
                          errorWidget: (context, url, error) => const Icon(
                              Icons.error,
                              size: 60), // Optional error widget
                        ),
                      ),
                    ),
                    trailing: Padding(
                      padding:
                          EdgeInsets.only(right: mediaQuery.screenWidth * 0.07),
                      child: InkWell(
                        onTap: () {
                          // Add your edit profile functionality here
                        },
                        child: Container(
                          width: 70,
                          height: 30,
                          decoration: const BoxDecoration(
                            color: AppColors.oRLightGrey,
                          ),
                          child: const Center(
                            child: Text('Edit Profile'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Text(
                  '@${user.username}',
                  style: const TextStyle(fontSize: 20),
                ),
                SizedBox(height: mediaQuery.screenHeight * 0.02),
                const Text('Nickname'),
                SizedBox(height: mediaQuery.screenHeight * 0.02),
                const Text(
                  'Experienced trader specializing in [specific] '
                  'market e.g., forex stocks with a focus on disciplined '
                  'risk management and data-driven strategies',
                ),
                SizedBox(height: mediaQuery.screenHeight * 0.02),
                Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        '0 Followers',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: mediaQuery.screenWidth * 0.1),
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        '0 Following',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(width: mediaQuery.screenWidth * 0.1),
                    InkWell(
                      onTap: () {},
                      child: const Text(
                        '0 Posts',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                const ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text(
                    'Location Not Available',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                const ListTile(
                  leading: Icon(Icons.card_membership),
                  title: Text(
                    'Member since Sep 2, 2024',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('User not found.'),
          );
        }
      },
    );
  }
}

Widget _buildShimmerEffect(MediaQueryHelper mediaQuery) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(vertical: mediaQuery.screenHeight * 0.04),
          child: ListTile(
            leading: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: CircleAvatar(
                maxRadius: 40,
                backgroundColor: Colors.grey[300],
              ),
            ),
            trailing: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 70,
                height: 30,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 20,
            width: mediaQuery.screenWidth * 0.5,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: mediaQuery.screenHeight * 0.02),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 15,
            width: mediaQuery.screenWidth * 0.3,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: mediaQuery.screenHeight * 0.02),
        Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 60,
            width: double.infinity,
            color: Colors.grey[300],
          ),
        ),
        SizedBox(height: mediaQuery.screenHeight * 0.02),
        Row(
          children: List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: mediaQuery.screenWidth * 0.03),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 15,
                  width: mediaQuery.screenWidth * 0.2,
                  color: Colors.grey[300],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: mediaQuery.screenHeight * 0.02),
        ListTile(
          leading: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Icon(Icons.location_on, color: Colors.grey[300]),
          ),
          title: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 12,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
        ),
        ListTile(
          leading: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Icon(Icons.card_membership, color: Colors.grey[300]),
          ),
          title: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 12,
              width: double.infinity,
              color: Colors.grey[300],
            ),
          ),
        ),
      ],
    ),
  );
}