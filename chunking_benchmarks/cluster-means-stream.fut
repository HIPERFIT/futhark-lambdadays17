-- ==
-- compiled input @ cluster-means.in
-- output @ cluster-means.out

include cluster_means_lib

default (f32)

fun main(cluster_sizes: [k]int) (points: [n][d]f32) (membership: [n]int): [k][d]f32 =
  streamRedPer (fn (acc: [k][d]f32) (elem: [k][d]f32) =>
                  map add_centroids acc elem)
               (fn (inp: [chunksize]([d]f32,int)) =>
                  let (points', membership') = unzip inp
                  in cluster_sums_seq cluster_sizes points' membership')
               (zip points membership)
