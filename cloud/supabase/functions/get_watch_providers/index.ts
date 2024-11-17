// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

// Setup type definitions for built-in Supabase Runtime APIs
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import { corsHeaders } from '../_shared/cors.ts'
import { TMDBApiUrl  } from '../_shared/constants.ts'


Deno.serve(async (req) => {
       if (req.method === 'OPTIONS') {
         return new Response('ok', { headers: corsHeaders })
       }
try {
    const url = new URL(req.url);
    const region = url.searchParams.get('region') || 'US';

     const options = {
        method: 'GET',
        headers: {
          accept: 'application/json',
          Authorization: `Bearer ${Deno.env.get('TMDB_APIKEY')}`,
        },
      };

    const responseMovieProviders = await fetch(
      `${TMDBApiUrl}/3/watch/providers/movie?watch_region=${region}`,
      options
    );
    const movieProviders = await responseMovieProviders.json();

    const responseTvShowProviders = await fetch(
          `${TMDBApiUrl}/3/watch/providers/tv?watch_region=${region}`,
          options
        );
        const tvShowProviders = await responseTvShowProviders.json();

      const combinedProviders = [
         ...movieProviders.results,
         ...tvShowProviders.results,
       ].reduce((acc, provider) => {
         if (!acc.some((p) => p.provider_id === provider.provider_id)) {
           acc.push(provider);
         }
         return acc;
       }, []);

       const data = {
         providers: combinedProviders,
       };

    return new Response(JSON.stringify(data), {
      headers: {...corsHeaders,"Content-Type": "application/json" },
    });
  } catch (err) {
    console.error("Error fetching movies:", err);

    return new Response(
      JSON.stringify({ error: "Failed to fetch movies" }),
      { headers: {...corsHeaders, "Content-Type": "application/json" }, status: 500 }
    );
  }
});
